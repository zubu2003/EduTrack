import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class CourseSelectorDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final String targetRoute;
  final Map<String, dynamic>? arguments;

  const CourseSelectorDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.targetRoute,
    this.arguments,
  });

  @override
  Widget build(BuildContext context) {
    // Sample course data (will come from backend later)
    final courses = [
      {
        'code': 'CSE 356',
        'name': 'Software Engineering',
        'section': 'A',
        'students': 42,
      },
      {
        'code': 'CSE 412',
        'name': 'Artificial Intelligence',
        'section': 'B',
        'students': 38,
      },
      {
        'code': 'CSE 201',
        'name': 'Data Structures',
        'section': 'A',
        'students': 45,
      },
      {
        'code': 'CSE 301',
        'name': 'Database Management',
        'section': 'C',
        'students': 35,
      },
    ];

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SSize.cardRadius),
      ),
      insetPadding: const EdgeInsets.all(SSize.defaultSpace),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(SSize.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle Bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: SColors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: SSize.spaceBtwItems),

            // Title
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: SColors.textPrimary,
              ),
            ),
            const SizedBox(height: SSize.xs),

            // Subtitle
            Text(
              subtitle,
              style: TextStyle(
                color: SColors.textSecondary,
                fontSize: SSize.fontSizeMd,
              ),
            ),
            const SizedBox(height: SSize.spaceBtwItems),

            // Divider
            Divider(
              color: SColors.grey.withOpacity(0.2),
              height: 1,
            ),
            const SizedBox(height: SSize.spaceBtwItems),

            // Course List
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: SSize.sm),
                    child: InkWell(
                      onTap: () {
                        Get.back(); // Close dialog
                        // Navigate to target screen with course details
                        Get.toNamed(
                          targetRoute,
                          arguments: {
                            'courseCode': course['code'],
                            'courseName': course['name'],
                            'students': course['students'],
                            'section': course['section'],
                          },
                        );
                      },
                      borderRadius: BorderRadius.circular(SSize.cardRadius),
                      child: Container(
                        padding: const EdgeInsets.all(SSize.md),
                        decoration: BoxDecoration(
                          color: SColors.white,
                          borderRadius: BorderRadius.circular(SSize.cardRadius),
                          border: Border.all(
                            color: SColors.grey.withOpacity(0.1),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: SColors.black.withOpacity(0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Icon
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: SColors.primary.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
                              ),
                              child: Icon(
                                Iconsax.book,
                                color: SColors.primary,
                                size: SSize.iconMd,
                              ),
                            ),
                            const SizedBox(width: SSize.spaceBtwItems),

                            // Course Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    course['code']! as String,
                                    style: TextStyle(
                                      color: SColors.textPrimary,
                                      fontSize: SSize.fontSizeMd,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: SSize.xs),
                                  Text(
                                    course['name']! as String,
                                    style: TextStyle(
                                      color: SColors.textSecondary,
                                      fontSize: SSize.fontSizeSm,
                                    ),
                                  ),
                                  const SizedBox(height: SSize.xs),
                                  Row(
                                    children: [
                                      Icon(
                                        Iconsax.people,
                                        color: SColors.grey,
                                        size: SSize.iconSm,
                                      ),
                                      const SizedBox(width: SSize.xs),
                                      Text(
                                        '${course['students']} Students',
                                        style: TextStyle(
                                          color: SColors.textSecondary,
                                          fontSize: SSize.fontSizeSm,
                                        ),
                                      ),
                                      const SizedBox(width: SSize.md),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: SSize.sm,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: SColors.primary.withOpacity(0.08),
                                          borderRadius: BorderRadius.circular(SSize.borderRadiusSm),
                                        ),
                                        child: Text(
                                          'Sec ${course['section']}',
                                          style: TextStyle(
                                            color: SColors.primary,
                                            fontSize: SSize.fontSizeSm,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Arrow
                            Icon(
                              Icons.arrow_forward_ios,
                              color: SColors.grey,
                              size: SSize.iconSm,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: SSize.spaceBtwItems),

            // Cancel Button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Get.back(),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: SSize.sm),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: SColors.textSecondary,
                    fontSize: SSize.fontSizeMd,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}