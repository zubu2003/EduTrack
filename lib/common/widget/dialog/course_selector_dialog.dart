import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/data/repositories/course/course_repository.dart';
import 'package:edutrack/data/repositories/user/user_repository.dart';
import 'package:edutrack/features/course/models/course_model.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/departments.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class CourseSelectorDialog extends StatelessWidget {
  final String title;
  final String subtitle;

  const CourseSelectorDialog({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_CourseSelectorController());

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SSize.cardRadius),
      ),
      insetPadding: const EdgeInsets.all(SSize.defaultSpace),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(SSize.md),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const SizedBox(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(color: SColors.primary),
              ),
            );
          }

          if (controller.courses.isEmpty) {
            return SizedBox(
              height: 200,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Iconsax.book,
                      size: 48,
                      color: SColors.grey,
                    ),
                    const SizedBox(height: SSize.sm),
                    Text(
                      'No courses available',
                      style: TextStyle(
                        color: SColors.textSecondary,
                        fontSize: SSize.fontSizeMd,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
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
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: SColors.textSecondary,
                  fontSize: SSize.fontSizeMd,
                ),
              ),
              const SizedBox(height: SSize.spaceBtwItems),

              Divider(color: SColors.grey.withOpacity(0.2), height: 1),
              const SizedBox(height: SSize.spaceBtwItems),

              // Course List
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.courses.length,
                  itemBuilder: (context, index) {
                    final course = controller.courses[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: SSize.sm),
                      child: InkWell(
                        onTap: () {
                          // ✅ Return the selected course
                          Get.back(result: course);
                        },
                        borderRadius:
                        BorderRadius.circular(SSize.cardRadius),
                        child: Container(
                          padding: const EdgeInsets.all(SSize.md),
                          decoration: BoxDecoration(
                            color: SColors.white,
                            borderRadius:
                            BorderRadius.circular(SSize.cardRadius),
                            border: Border.all(
                              color: SColors.grey.withOpacity(0.15),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color:
                                  SColors.primary.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(
                                      SSize.borderRadiusMd),
                                ),
                                child: Icon(
                                  Iconsax.book,
                                  color: SColors.primary,
                                  size: SSize.iconMd,
                                ),
                              ),
                              const SizedBox(width: SSize.spaceBtwItems),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      course.courseCode,
                                      style: TextStyle(
                                        color: SColors.textPrimary,
                                        fontSize: SSize.fontSizeMd,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: SSize.xs),
                                    Text(
                                      course.courseName,
                                      style: TextStyle(
                                        color: SColors.textSecondary,
                                        fontSize: SSize.fontSizeSm,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
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
                                          '${course.totalStudents} Students',
                                          style: TextStyle(
                                            color: SColors.textSecondary,
                                            fontSize: SSize.fontSizeSm,
                                          ),
                                        ),
                                        const SizedBox(width: SSize.sm),
                                        Container(
                                          padding:
                                          const EdgeInsets.symmetric(
                                            horizontal: SSize.sm,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: SColors.primary
                                                .withOpacity(0.08),
                                            borderRadius:
                                            BorderRadius.circular(
                                                SSize.borderRadiusSm),
                                          ),
                                          child: Text(
                                            'Sec ${course.section}',
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
          );
        }),
      ),
    );
  }
}

/// Controller to fetch teacher's courses
class _CourseSelectorController extends GetxController {
  RxList<CourseModel> courses = <CourseModel>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    try {
      isLoading.value = true;
      final user = await UserRepository.instance.getCurrentUserData();
      if (user == null) return;

      final list =
      await CourseRepository.instance.getTeacherCourses(user.uid);
      courses.value = list;
    } catch (e) {
      // silent
    } finally {
      isLoading.value = false;
    }
  }
}