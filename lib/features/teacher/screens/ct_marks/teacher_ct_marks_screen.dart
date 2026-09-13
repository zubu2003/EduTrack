import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/common/widget/bottom_nav/teacher_bottom_nav.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/features/teacher/screens/ct_marks/upload_ct_marks_screen.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';
import 'widgets/ct_marks_header.dart';
import 'widgets/ct_marks_list_item.dart';

class TeacherCtMarksScreen extends StatelessWidget {
  final CourseModel course;

  const TeacherCtMarksScreen({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    // Hardcoded CT data (will be replaced with backend later)
    final ctList = [
      {
        'id': 1,
        'title': 'CT-1',
        'date': 'Oct 12, 2023',
        'fullMarks': 20,
        'status': 'Published',
      },
      {
        'id': 2,
        'title': 'CT-2',
        'date': 'Nov 05, 2023',
        'fullMarks': 20,
        'status': 'Draft',
      },
      {
        'id': 3,
        'title': 'CT-3',
        'date': 'Dec 10, 2023',
        'fullMarks': 20,
        'status': 'Published',
      },
    ];

    return Scaffold(
      backgroundColor: SColors.backgroundColor,
      appBar: SAppbar(
        showBackButton: true,
        onBackPressed: () => Get.back(),
      ),
      body: Column(
        children: [
          // Header
          CtMarksHeader(
            courseCode: course.courseCode,
            courseName: course.courseName,
          ),
          const SizedBox(height: SSize.spaceBtwItems),

          // CT List
          Expanded(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: SSize.defaultSpace),
              child: ListView.builder(
                itemCount: ctList.length,
                itemBuilder: (context, index) {
                  final ct = ctList[index];
                  return Padding(
                    padding:
                    const EdgeInsets.only(bottom: SSize.spaceBtwItems),
                    child: CtMarksListItem(
                      title: ct['title']! as String,
                      date: ct['date']! as String,
                      fullMarks: ct['fullMarks']! as int,
                      status: ct['status']! as String,
                      onTap: () {
                        Get.to(
                              () => UploadCtMarksScreen(
                            course: course,
                            ctTitle: ct['title']! as String,
                            fullMarks: ct['fullMarks']! as int,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.snackbar(
            'Coming Soon',
            'Create new CT feature coming soon!',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
        },
        backgroundColor: SColors.primary,
        child: const Icon(
          Iconsax.add,
          color: SColors.white,
          size: 28,
        ),
      ),
      bottomNavigationBar: const TeacherBottomNav(
        currentIndex: 1,
      ),
    );
  }
}