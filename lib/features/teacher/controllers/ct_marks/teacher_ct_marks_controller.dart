import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:edutrack/data/repositories/ct_marks/ct_marks_repository.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/features/course/models/ct_data_model.dart';
import 'package:edutrack/common/widget/loader/full_screen_loader.dart';
import 'package:edutrack/utils/popups/snackbar_helpers.dart';

import '../../../../data/services/excel/excel_service.dart';

class TeacherCtMarksController extends GetxController {
  final CourseModel course;

  TeacherCtMarksController({required this.course});

  // Course CT data
  Rx<CtDataModel?> ctData = Rx<CtDataModel?>(null);
  RxBool isLoading = true.obs;

  // Upload flow
  Uint8List? _uploadedFileBytes;
  String? _uploadedFileName;
  Rx<ParsedExcelData?> parsedData = Rx<ParsedExcelData?>(null);
  RxBool isUploading = false.obs;

  // Editable preview: { "CT-1": { uid: mark } }
  RxMap<String, Map<String, double>> editableMarks =
      <String, Map<String, double>>{}.obs;
  RxMap<String, double> editableTotals = <String, double>{}.obs;
  Rx<double> editableFullMarks = 20.0.obs;

  // Manual CT creation
  final manualCtFormKey = GlobalKey<FormState>();
  final manualCtTitleController = TextEditingController();
  final manualFullMarksController = TextEditingController(text: '20');

  @override
  void onInit() {
    super.onInit();
    fetchCtData();
  }

  // ─── FETCH ───

  Future<void> fetchCtData() async {
    try {
      isLoading.value = true;
      final data = await CtMarksRepository.instance.getCtData(course.courseId);
      ctData.value = data;
    } catch (e) {
      SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ─── UPLOAD EXCEL ───

  /// Pick file and parse it
  Future<bool> pickAndParseExcel() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
        withData: true,
      );

      if (result == null || result.files.isEmpty) return false;

      final file = result.files.first;
      if (file.bytes == null) {
        SSnackBarHelpers.errorSnackBar(
          title: 'Error',
          message: 'Could not read file bytes',
        );
        return false;
      }

      _uploadedFileBytes = file.bytes;
      _uploadedFileName = file.name;

      // Parse
      final parsed = ExcelService.instance.parseCtMarks(file.bytes!);
      parsedData.value = parsed;

      // Prepare editable maps
      _prepareEditableData(parsed);

      if (parsed.hasErrors) {
        SSnackBarHelpers.warningSnackBar(
          title: 'Partial Parse',
          message: '${parsed.errors.length} issues found',
        );
      }

      return true;
    } catch (e) {
      SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
      return false;
    }
  }

  void _prepareEditableData(ParsedExcelData parsed) {
    editableMarks.clear();
    for (final entry in parsed.marksByCt.entries) {
      editableMarks[entry.key] = Map<String, double>.from(entry.value);
    }
    editableTotals.clear();
    editableTotals.addAll(parsed.totals);
  }

  /// Update an editable cell
  void updateEditableMark(String ctTitle, String studentId, double mark) {
    if (!editableMarks.containsKey(ctTitle)) {
      editableMarks[ctTitle] = {};
    }
    editableMarks[ctTitle]![studentId] = mark;
    editableMarks.refresh();
  }

  /// Update editable total
  void updateEditableTotal(String studentId, double total) {
    editableTotals[studentId] = total;
    editableTotals.refresh();
  }

  /// Submit parsed & edited data to Firestore
  Future<void> submitParsedData() async {
    try {
      final parsed = parsedData.value;
      if (parsed == null) {
        SSnackBarHelpers.warningSnackBar(
          title: 'No Data',
          message: 'Please upload an Excel file first',
        );
        return;
      }

      print('🔵 [CT] submitParsedData called');
      print('🔵 [CT] courseId: ${course.courseId}');
      print('🔵 [CT] editableMarks keys: ${editableMarks.keys.toList()}');

      editableMarks.forEach((ct, marks) {
        print('🔵 [CT] $ct → ${marks.length} students');
      });

      print('🔵 [CT] editableTotals: ${editableTotals.length}');
      print('🔵 [CT] fullMarks: ${editableFullMarks.value}');

      isUploading.value = true;
      SFullScreenLoader.openLoadingDialog('Saving marks...');

      // Convert RxMap to plain maps
      final marksByCt = <String, Map<String, double>>{};
      editableMarks.forEach((ct, marks) {
        marksByCt[ct] = Map<String, double>.from(marks);
      });

      final totals = <String, double>{};
      editableTotals.forEach((uid, val) {
        totals[uid] = val;
      });

      print('🔵 [CT] marksByCt (plain): $marksByCt');
      print('🔵 [CT] totals (plain): $totals');

      print('🔵 [CT] Calling repository.mergeExcelData...');

      await CtMarksRepository.instance.mergeExcelData(
        courseId: course.courseId,
        marksByCt: marksByCt,
        totals: totals,
        fullMarks: editableFullMarks.value,
        bestOfCount: course.credit > 0 ? course.credit : 3,
        totalCTs: course.credit > 0 ? course.credit + 1 : 4,
      );

      print('✅ [CT] mergeExcelData succeeded');

      SFullScreenLoader.stopLoading();
      isUploading.value = false;

      SSnackBarHelpers.successSnackBar(
        title: 'Success',
        message: 'Marks saved successfully',
      );

      clearUploadState();
      await fetchCtData();
      Get.back();
    } catch (e, stack) {
      SFullScreenLoader.stopLoading();
      isUploading.value = false;
      print('❌ [CT] submitParsedData error: $e');
      print('❌ [CT] Stack: $stack');
      SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  void clearUploadState() {
    _uploadedFileBytes = null;
    _uploadedFileName = null;
    parsedData.value = null;
    editableMarks.clear();
    editableTotals.clear();
  }

  // ─── PER-CT EDIT ───

  /// Update marks of a single CT
  Future<void> saveCtMarks({
    required String ctTitle,
    required Map<String, double> marks,
  }) async {
    try {
      SFullScreenLoader.openLoadingDialog('Saving marks...');

      await CtMarksRepository.instance.updateCtMarks(
        courseId: course.courseId,
        ctTitle: ctTitle,
        marks: marks,
      );

      SFullScreenLoader.stopLoading();
      SSnackBarHelpers.successSnackBar(
        title: 'Success',
        message: 'CT marks updated',
      );

      await fetchCtData();
      Get.back();
    } catch (e) {
      SFullScreenLoader.stopLoading();
      SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  /// Update status of a CT
  Future<void> changeCtStatus({
    required String ctTitle,
    required String status,
  }) async {
    try {
      await CtMarksRepository.instance.updateCtStatus(
        courseId: course.courseId,
        ctTitle: ctTitle,
        status: status,
      );

      SSnackBarHelpers.successSnackBar(
        title: 'Updated',
        message: 'Status changed to $status',
      );

      await fetchCtData();
    } catch (e) {
      SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  // ─── MANUAL CT CREATION ───

  Future<void> createManualCt() async {
    try {
      if (!manualCtFormKey.currentState!.validate()) return;

      final ctTitle = manualCtTitleController.text.trim().toUpperCase();
      final fullMarks =
          double.tryParse(manualFullMarksController.text.trim()) ?? 20;

      SFullScreenLoader.openLoadingDialog('Creating CT...');

      await CtMarksRepository.instance.initializeCtData(
        courseId: course.courseId,
        fullMarks: fullMarks,
        bestOfCount: course.credit > 0 ? course.credit : 3,
        totalCTs: course.credit > 0 ? course.credit + 1 : 4,
      );

      await CtMarksRepository.instance.createManualCt(
        courseId: course.courseId,
        ctTitle: ctTitle,
        fullMarks: fullMarks,
      );

      SFullScreenLoader.stopLoading();
      SSnackBarHelpers.successSnackBar(
        title: 'Success',
        message: '$ctTitle created',
      );

      manualCtTitleController.clear();
      await fetchCtData();
      Get.back();
    } catch (e) {
      SFullScreenLoader.stopLoading();
      SSnackBarHelpers.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  /// Delete a CT
  Future<void> deleteCt(String ctTitle) async {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Delete CT'),
        content: Text('Delete "$ctTitle" and all its marks?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Get.back();
              try {
                await CtMarksRepository.instance.deleteCt(
                  courseId: course.courseId,
                  ctTitle: ctTitle,
                );
                SSnackBarHelpers.successSnackBar(
                  title: 'Deleted',
                  message: '$ctTitle deleted',
                );
                await fetchCtData();
              } catch (e) {
                SSnackBarHelpers.errorSnackBar(
                    title: 'Error', message: e.toString());
              }
            },
            child:
            const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    manualCtTitleController.dispose();
    manualFullMarksController.dispose();
    super.onClose();
  }
}