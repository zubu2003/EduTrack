import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/common/widget/bottom_nav/student_bottom_nav.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';
import 'widgets/ct_marks_header.dart';
import 'widgets/ct_marks_summary.dart';
import 'widgets/ct_marks_list_item.dart';

class StudentCtMarksScreen extends StatelessWidget {
  final String courseCode;
  final String courseName;

  const StudentCtMarksScreen({
    super.key,
    required this.courseCode,
    required this.courseName,
  });

  @override
  Widget build(BuildContext context) {
    // Hardcoded CT data outside builder
    final List<Map<String, dynamic>> ctList = [
      {
        'title': 'Class Test 1',
        'marks': '17/20',
        'date': 'Oct 12, 2023',
        'icon': Iconsax.document_text,
      },
      {
        'title': 'Class Test 2',
        'marks': '15/20',
        'date': 'Nov 05, 2023',
        'icon': Iconsax.document,
      },
      {
        'title': 'Class Test 3',
        'marks': '18/20',
        'date': 'Dec 10, 2023',
        'icon': Iconsax.document,
      },
      {
        'title': 'Class Test 4',
        'marks': '14/20',
        'date': 'Jan 15, 2024',
        'icon': Iconsax.document,
      },
    ];

    return Scaffold(
      backgroundColor: SColors.backgroundColor,
      appBar: SAppbar(
        showBackButton: true,
        onBackPressed: () => Get.back(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SSize.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: SSize.sm),

              // Header
              CtMarksHeader(
                courseCode: courseCode,
                courseName: courseName,
              ),

              const SizedBox(height: SSize.spaceBtwItems),

              // Summary Card
              const CtMarksSummary(),

              const SizedBox(height: SSize.spaceBtwItems),

              // CT List Title
              Text(
                'All Class Tests',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: SColors.textPrimary,
                ),
              ),

              const SizedBox(height: SSize.spaceBtwItems),

              // CT List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: ctList.length,
                itemBuilder: (context, index) {
                  final ct = ctList[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: SSize.spaceBtwItems),
                    child: CtMarksListItem(
                      title: ct['title'] as String,
                      marks: ct['marks'] as String,
                      date: ct['date'] as String,
                      icon: ct['icon'] as IconData,
                    ),
                  );
                },
              ),

              const SizedBox(height: SSize.spaceBtwSections),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const StudentBottomNav(
        currentIndex: 1,
      ),
    );
  }
}