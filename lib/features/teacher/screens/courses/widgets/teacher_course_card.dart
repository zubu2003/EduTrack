import 'package:flutter/material.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/departments.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class TeacherCourseCard extends StatelessWidget {
  final CourseModel course;
  final VoidCallback onTap;       //  Tap to view course details
  final VoidCallback onAssign;    // Assign students
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TeacherCourseCard({
    super.key,
    required this.course,
    required this.onTap,
    required this.onAssign,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,  //  Tap card opens Course Details
      borderRadius: BorderRadius.circular(SSize.cardRadius),
      child: Container(
        padding: const EdgeInsets.all(SSize.md),
        decoration: BoxDecoration(
          color: SColors.white,
          borderRadius: BorderRadius.circular(SSize.cardRadius),
          boxShadow: [
            BoxShadow(
              color: SColors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                Container(
                  width: 4,
                  height: 40,
                  decoration: BoxDecoration(
                    color: SColors.primary,
                    borderRadius: BorderRadius.circular(SSize.borderRadiusSm),
                  ),
                ),
                const SizedBox(width: SSize.sm),
                Expanded(
                  child: Text(
                    course.courseCode,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: SColors.textPrimary,
                    ),
                  ),
                ),
                // Menu
                PopupMenuButton<String>(
                  icon: Icon(Iconsax.more, color: SColors.grey),
                  onSelected: (value) {
                    if (value == 'edit') onEdit();
                    if (value == 'delete') onDelete();
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Iconsax.edit, size: 18),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Iconsax.trash, color: Colors.red, size: 18),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: SSize.sm),

            // Course Name
            Text(
              course.courseName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SSize.sm),

            // Info Chips
            Wrap(
              spacing: SSize.md,
              runSpacing: SSize.xs,
              children: [
                _buildInfoChip(Iconsax.calendar, 'Batch ${course.batch}'),
                _buildInfoChip(
                  Iconsax.building,
                  SDepartments.getDeptName(course.department),
                ),
                _buildInfoChip(Iconsax.people, 'Sec ${course.section}'),
                _buildInfoChip(
                  Iconsax.user,
                  '${course.totalStudents} students',
                ),
              ],
            ),
            const SizedBox(height: SSize.md),

            //  Button: "Manage Students" (clearer than "Assign Students")
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: onAssign,
                icon: const Icon(Iconsax.user_add, size: 18),
                label: const Text('Manage Students'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: SColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: SColors.grey),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: SColors.textSecondary,
            fontSize: SSize.fontSizeSm,
          ),
        ),
      ],
    );
  }
}