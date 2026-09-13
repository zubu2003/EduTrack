import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'widgets/upload_ct_marks_header.dart';
import 'widgets/upload_ct_marks_form.dart';
import 'widgets/upload_ct_marks_actions.dart';

class UploadCtMarksScreen extends StatelessWidget {
  final CourseModel course;
  final String ctTitle;
  final int fullMarks;

  const UploadCtMarksScreen({
    super.key,
    required this.course,
    required this.ctTitle,
    required this.fullMarks,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SColors.backgroundColor,
      appBar: SAppbar(
        showBackButton: true,
        onBackPressed: () => Get.back(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(SSize.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              UploadCtMarksHeader(
                courseCode: course.courseCode,
                ctTitle: ctTitle,
              ),

              const SizedBox(height: SSize.spaceBtwSections),

              // Form
              const UploadCtMarksForm(),

              const SizedBox(height: SSize.spaceBtwSections),

              // Actions
              const UploadCtMarksActions(),
            ],
          ),
        ),
      ),
    );
  }
}