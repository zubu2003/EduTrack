import 'dart:typed_data';
import 'package:excel/excel.dart';

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

  /// Parse Excel bytes → structured data
  ///
  /// Expected columns:
  ///   Column A (index 0): Student ID or Roll
  ///   Columns B+ : CT-1, CT-2, ... , Total (optional)
  ParsedExcelData parseCtMarks(Uint8List fileBytes) {
    final errors = <String>[];
    final ctColumns = <String>[];
    final marksByCt = <String, Map<String, double>>{};
    final totals = <String, double>{};
    int totalRows = 0;

    try {
      final excel = Excel.decodeBytes(fileBytes);
      if (excel.tables.isEmpty) {
        return ParsedExcelData(
          ctColumns: [],
          marksByCt: {},
          totals: {},
          totalRows: 0,
          errors: ['Excel file is empty'],
        );
      }

      // Get first sheet
      final sheetName = excel.tables.keys.first;
      final sheet = excel.tables[sheetName]!;

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

      // Detect CT columns and Total column
      int idColumnIndex = 0;
      int? totalColumnIndex;

      for (int col = 1; col < headerRow.length; col++) {
        final cell = headerRow[col];
        if (cell == null) continue;

        final headerText = cell.value.toString().trim();
        if (headerText.isEmpty) continue;

        final lowerHeader = headerText.toLowerCase();

        if (lowerHeader.contains('total') || lowerHeader.contains('best')) {
          totalColumnIndex = col;
        } else if (lowerHeader.contains('ct') ||
            RegExp(r'\d+').hasMatch(lowerHeader)) {
          // Normalize CT name: "ct 1" → "CT-1"
          final normalized = _normalizeCtName(headerText);
          ctColumns.add(normalized);

          // Initialize marks map for this CT
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

        // Read student ID from column A
        final idCell = row.isNotEmpty ? row[idColumnIndex] : null;
        if (idCell == null || idCell.value == null) continue;

        final studentId = idCell.value.toString().trim();
        if (studentId.isEmpty) continue;

        totalRows++;

        // Read CT marks
        int ctColCounter = 0;
        for (int col = 1; col < headerRow.length; col++) {
          final cell = row.length > col ? row[col] : null;
          if (cell == null || cell.value == null) continue;

          // Skip Total column here
          if (col == totalColumnIndex) continue;

          // Only process columns we identified as CTs
          if (ctColCounter >= ctColumns.length) break;

          final ctName = ctColumns[ctColCounter];
          final valueStr = cell.value.toString().trim();

          if (valueStr.isNotEmpty) {
            final mark = double.tryParse(valueStr);
            if (mark != null) {
              marksByCt[ctName]![studentId] = mark;
            } else {
              errors.add(
                  'Row ${rowIdx + 1}, $ctName: Invalid mark "$valueStr"');
            }
          }

          ctColCounter++;
        }

        // Read Total column (if present)
        if (totalColumnIndex != null &&
            row.length > totalColumnIndex &&
            row[totalColumnIndex] != null &&
            row[totalColumnIndex]!.value != null) {
          final totalStr =
          row[totalColumnIndex]!.value.toString().trim();
          if (totalStr.isNotEmpty) {
            final total = double.tryParse(totalStr);
            if (total != null) {
              totals[studentId] = total;
            }
          }
        }
      }
    } catch (e) {
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

  /// Normalize CT header → canonical form
  /// "CT 1" → "CT-1"
  /// "ct-2" → "CT-2"
  /// "CT-3" → "CT-3"
  String _normalizeCtName(String raw) {
    final cleaned = raw.toUpperCase().replaceAll(' ', '-').trim();
    // Ensure format CT-X
    final match = RegExp(r'CT-?(\d+)').firstMatch(cleaned);
    if (match != null) {
      return 'CT-${match.group(1)}';
    }
    return cleaned;
  }
}