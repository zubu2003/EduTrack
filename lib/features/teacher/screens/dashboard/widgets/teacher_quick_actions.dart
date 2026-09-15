import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/dialog/course_selector_dialog.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/features/teacher/screens/attendance/take_attendance_screen.dart';
import 'package:edutrack/features/teacher/screens/ct_marks/teacher_ct_marks_screen.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class TeacherQuickActions extends StatelessWidget {
  const TeacherQuickActions({super.key});

  Future<void> _showCourseSelector(
      BuildContext context, {
        required String title,
        required String subtitle,
        required void Function(CourseModel) onCourseSelected,
      }) async {
    final result = await showDialog<CourseModel>(
      context: context,
      barrierDismissible: true,
      builder: (context) => CourseSelectorDialog(
        title: title,
        subtitle: subtitle,
      ),
    );

    if (result != null) {
      onCourseSelected(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final actions = [
      {
        'label': 'Take Attendance',
        'icon': Iconsax.clipboard_tick,
        'color': SColors.primary,
        'title': 'Take Attendance',
        'subtitle': 'Choose a course to take attendance',
        'type': 'attendance',
      },
      {
        'label': 'CT Marks',
        'icon': Iconsax.document_upload,
        'color': const Color(0xFF6C63FF),
        'title': 'CT Marks',
        'subtitle': 'Choose a course to manage CT marks',
        'type': 'ct_marks',
      },
      {
        'label': 'Send Announcement',
        'icon': Iconsax.notification,
        'color': const Color(0xFF4A90D9),
        'title': 'Send Announcement',
        'subtitle': 'Choose a course to send announcement',
        'type': null,
      },
      {
        'label': 'View Reports',
        'icon': Iconsax.chart,
        'color': const Color(0xFF1A1A2E),
        'title': 'View Reports',
        'subtitle': 'Choose a course to view reports',
        'type': null,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: SColors.textPrimary,
          ),
        ),
        const SizedBox(height: SSize.spaceBtwItems),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: SSize.spaceBtwItems,
            mainAxisSpacing: SSize.spaceBtwItems,
            childAspectRatio: 1.2,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return _buildActionCard(
              context,
              label: action['label'] as String,
              icon: action['icon'] as IconData,
              color: action['color'] as Color,
              title: action['title'] as String,
              subtitle: action['subtitle'] as String,
              type: action['type'] as String?,
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionCard(
      BuildContext context, {
        required String label,
        required IconData icon,
        required Color color,
        required String title,
        required String subtitle,
        required String? type,
      }) {
    return InkWell(
      onTap: () {
        if (type == null) {
          Get.snackbar(
            'Coming Soon',
            '$label feature coming soon!',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
          return;
        }

        if (type == 'attendance') {
          _showCourseSelector(
            context,
            title: title,
            subtitle: subtitle,
            onCourseSelected: (course) {
              Get.to(() => TakeAttendanceScreen(course: course));
            },
          );
        } else if (type == 'ct_marks') {
          _showCourseSelector(
            context,
            title: title,
            subtitle: subtitle,
            onCourseSelected: (course) {
              Get.to(() => TeacherCtMarksScreen(course: course));
            },
          );
        }
      },
      borderRadius: BorderRadius.circular(SSize.cardRadius),
      child: Container(
        padding: const EdgeInsets.all(SSize.sm),
        decoration: BoxDecoration(
          color: SColors.white,
          borderRadius: BorderRadius.circular(SSize.cardRadius),
          boxShadow: [
            BoxShadow(
              color: SColors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: color.withOpacity(0.15),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
              ),
              child: Icon(
                icon,
                color: color,
                size: SSize.iconMd,
              ),
            ),
            const SizedBox(height: SSize.sm),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: SColors.textPrimary,
                fontSize: SSize.fontSizeSm,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}