import 'dart:typed_data';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:edutrack/features/course/models/ct_data_model.dart';

/// Result of parsing an Excel file
class ParsedExcelData {
  final List<String> ctColumns; // ["CT-1", "CT-2", ...]
  final Map<String, Map<String, double>> marksByCt; // { "CT-1": { "2204001": 17 } }
  final Map<String, double> totals; // { "2204001": 50 }
  final int totalRows;
  final List<String> errors;

  ParsedExcelData({
    required this.ctColumns,
    required this.marksByCt,
    required this.totals,
    required this.totalRows,
    required this.errors,
  });

  bool get hasErrors => errors.isNotEmpty;
}

class ExcelService {
  static final ExcelService instance = ExcelService._();
  ExcelService._();

  ParsedExcelData parseCtMarks(Uint8List fileBytes) {
    final errors = <String>[];
    final ctColumns = <String>[];
    final marksByCt = <String, Map<String, double>>{};
    final totals = <String, double>{};
    int totalRows = 0;

    try {
      final decoder = SpreadsheetDecoder.decodeBytes(fileBytes, update: false);
      if (decoder.tables.isEmpty) {
        return ParsedExcelData(
          ctColumns: [],
          marksByCt: {},
          totals: {},
          totalRows: 0,
          errors: ['Excel file is empty'],
        );
      }

      // Get first sheet
      final sheetName = decoder.tables.keys.first;
      final sheet = decoder.tables[sheetName]!;

      if (sheet.maxRows < 2) {
        return ParsedExcelData(
          ctColumns: [],
          marksByCt: {},
          totals: {},
          totalRows: 0,
          errors: ['Excel needs at least a header row and one data row'],
        );
      }

      // Read header row
      final headerRow = sheet.rows[0];
      if (headerRow.length < 2) {
        return ParsedExcelData(
          ctColumns: [],
          marksByCt: {},
          totals: {},
          totalRows: 0,
          errors: ['Excel needs at least 2 columns (ID + marks)'],
        );
      }

      int idColumnIndex = 0;
      int? totalColumnIndex;
      final Map<int, String> ctColMap = {};

      for (int col = 0; col < headerRow.length; col++) {
        final headerText = _extractValueString(headerRow[col]);
        if (headerText.isEmpty) continue;

        final lowerHeader = headerText.toLowerCase();

        // Detect ID/Roll column dynamically (defaults to 0)
        if (lowerHeader == 'id' ||
            lowerHeader.contains('student id') ||
            lowerHeader.contains('roll')) {
          idColumnIndex = col;
          continue;
        }

        // Safely ignore Name or Serial columns
        if (lowerHeader == 'name' ||
            lowerHeader.contains('student name') ||
            lowerHeader == 'sl' ||
            lowerHeader == 's/n') {
          continue;
        }

        if (lowerHeader.contains('total') || lowerHeader.contains('best')) {
          totalColumnIndex = col;
        } else if (lowerHeader.contains('ct') ||
            RegExp(r'\d+').hasMatch(lowerHeader)) {
          final normalized = _normalizeCtName(headerText);
          if (!ctColumns.contains(normalized)) {
            ctColumns.add(normalized);
          }
          ctColMap[col] = normalized;
          marksByCt[normalized] = {};
        }
      }

      if (ctColumns.isEmpty && totalColumnIndex == null) {
        return ParsedExcelData(
          ctColumns: [],
          marksByCt: {},
          totals: {},
          totalRows: 0,
          errors: ['No CT columns or Total column found in header'],
        );
      }

      // Parse data rows
      for (int rowIdx = 1; rowIdx < sheet.maxRows; rowIdx++) {
        final row = sheet.rows[rowIdx];
        if (row.isEmpty) continue;

        final studentId = row.length > idColumnIndex
            ? _extractValueString(row[idColumnIndex])
            : '';
        if (studentId.isEmpty) continue;

        totalRows++;

        // Iterate strictly over mapped CT column indices
        for (final entry in ctColMap.entries) {
          final colIdx = entry.key;
          final ctName = entry.value;

          if (row.length <= colIdx) continue;
          final valueStr = _extractValueString(row[colIdx]);

          if (valueStr.isNotEmpty) {
            if (CtMark.isAbsentText(valueStr)) {
              marksByCt[ctName]![studentId] = CtMark.absent;
            } else {
              final mark = double.tryParse(valueStr);
              if (mark != null) {
                marksByCt[ctName]![studentId] = mark;
              } else {
                errors.add(
                    'Row ${rowIdx + 1}, $ctName: Invalid mark "$valueStr"');
              }
            }
          }
        }

        // Read Total column (if present)
        if (totalColumnIndex != null && row.length > totalColumnIndex) {
          final totalStr = _extractValueString(row[totalColumnIndex]);
          if (totalStr.isNotEmpty) {
            final total = double.tryParse(totalStr);
            if (total != null) {
              totals[studentId] = total;
            }
          }
        }
      }
    } catch (e, stackTrace) {
      print('EXCEL ERROR: $e');
      print('STACK TRACE: $stackTrace');
      errors.add('Failed to parse Excel: $e');
    }

    return ParsedExcelData(
      ctColumns: ctColumns,
      marksByCt: marksByCt,
      totals: totals,
      totalRows: totalRows,
      errors: errors,
    );
  }

  /// Safely extracts clean text from raw cell values
  String _extractValueString(dynamic val) {
    if (val == null) return '';
    if (val is num) {
      // Remove trailing .0 for whole numbers (e.g. 2204001.0 -> 2204001)
      return val == val.toInt() ? val.toInt().toString() : val.toString();
    }
    final str = val.toString().trim();
    if (str.endsWith('.0')) return str.substring(0, str.length - 2);
    return str;
  }

  /// Normalize CT header -> canonical form
  String _normalizeCtName(String raw) {
    final cleaned = raw.toUpperCase().replaceAll(' ', '-').trim();
    final match = RegExp(r'CT-?(\d+)').firstMatch(cleaned);
    if (match != null) {
      return 'CT-${match.group(1)}';
    }
    return cleaned;
  }
}