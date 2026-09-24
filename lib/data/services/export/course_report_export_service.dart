import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/features/course/models/course_report_model.dart';

class CourseReportExportService {
  static final instance = CourseReportExportService._();

  CourseReportExportService._();

  Future<void> sharePdf({
    required CourseModel course,
    required CourseReportStats stats,
    required CourseReportModel report,
  }) async {
    final bytes = await _pdfBytes(course: course, stats: stats, report: report);
    await Printing.sharePdf(
      bytes: bytes,
      filename: '${_safeName(course.courseCode)}_course_report.pdf',
    );
  }

  Future<File> exportExcel({
    required CourseModel course,
    required CourseReportStats stats,
    required CourseReportModel report,
  }) async {
    final workbook = Excel.createExcel();
    final sheet = workbook['Course Report'];
    sheet.appendRow([TextCellValue('Course Report')]);
    sheet.appendRow([
      TextCellValue('Course'),
      TextCellValue(course.courseName),
    ]);
    sheet.appendRow([TextCellValue('Code'), TextCellValue(course.courseCode)]);
    sheet.appendRow([]);
    sheet.appendRow([TextCellValue('Statistics')]);
    sheet.appendRow([
      TextCellValue('Total students'),
      IntCellValue(stats.totalStudents),
    ]);
    sheet.appendRow([
      TextCellValue('Average attendance'),
      TextCellValue('${stats.averageAttendance.toStringAsFixed(1)}%'),
    ]);
    sheet.appendRow([
      TextCellValue('Average CT marks'),
      TextCellValue('${stats.averageCt.toStringAsFixed(1)} / 20'),
    ]);
    sheet.appendRow([
      TextCellValue('At-risk students'),
      IntCellValue(stats.atRiskCount),
    ]);
    sheet.appendRow([]);
    sheet.appendRow([
      TextCellValue('Overview'),
      TextCellValue(report.overview),
    ]);
    sheet.appendRow([
      TextCellValue('Attendance Summary'),
      TextCellValue(report.attendanceSummary),
    ]);
    sheet.appendRow([
      TextCellValue('CT Performance'),
      TextCellValue(report.ctSummary),
    ]);
    sheet.appendRow([
      TextCellValue('Risks'),
      TextCellValue(report.risks.join('\n')),
    ]);
    sheet.appendRow([
      TextCellValue('Recommendations'),
      TextCellValue(report.recommendations.join('\n')),
    ]);

    final bytes = workbook.encode();
    if (bytes == null) throw StateError('Could not create Excel report');
    final directory = await getApplicationDocumentsDirectory();
    final file = File(
      '${directory.path}/${_safeName(course.courseCode)}_course_report.xlsx',
    );
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  Future<Uint8List> _pdfBytes({
    required CourseModel course,
    required CourseReportStats stats,
    required CourseReportModel report,
  }) async {
    final document = pw.Document();
    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(level: 0, child: pw.Text(_pdfSafe('Course Report'))),
          pw.Text(_pdfSafe('${course.courseName} (${course.courseCode})')),
          pw.SizedBox(height: 16),
          _pdfSection('Statistics', [
            'Total students: ${stats.totalStudents}',
            _pdfSafe(
              'Average attendance: ${stats.averageAttendance.toStringAsFixed(1)}%',
            ),
            _pdfSafe(
              'Average CT marks: ${stats.averageCt.toStringAsFixed(1)} / 20',
            ),
            _pdfSafe('At-risk students: ${stats.atRiskCount}'),
          ]),
          _pdfSection('Overview', [report.overview]),
          _pdfSection('Attendance Summary', [report.attendanceSummary]),
          _pdfSection('CT Performance', [report.ctSummary]),
          _pdfSection('Risks', report.risks),
          _pdfSection('Recommendations', report.recommendations),
        ],
      ),
    );
    return document.save();
  }

  pw.Widget _pdfSection(String title, List<String> lines) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 12),
        pw.Text(
          _pdfSafe(title),
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 4),
        ...lines.map(
          (line) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 3),
            child: pw.Text(_pdfSafe(line)),
          ),
        ),
      ],
    );
  }

  String _pdfSafe(String value) {
    return value
        .replaceAll('\u2018', "'")
        .replaceAll('\u2019', "'")
        .replaceAll('\u201C', '"')
        .replaceAll('\u201D', '"')
        .replaceAll('\u2013', '-')
        .replaceAll('\u2014', '-')
        .replaceAll('\u2212', '-')
        .replaceAll('\u2022', '*')
        .replaceAll('\u00A0', ' ')
        .split('')
        .where((character) => character.codeUnitAt(0) <= 255)
        .join();
  }

  String _safeName(String value) {
    final safe = value.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
    return safe.isEmpty ? 'course' : safe;
  }
}
