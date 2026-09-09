import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class AttendanceSummaryFooter extends StatelessWidget {
  final int presentCount;
  final int absentCount;
  final bool isEditing;

  const AttendanceSummaryFooter({
    super.key,
    required this.presentCount,
    required this.absentCount,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: SSize.defaultSpace),
      child: Column(
        children: [
          // Summary Row
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(SSize.md),
            decoration: BoxDecoration(
              color: SColors.white,
              borderRadius: BorderRadius.circular(SSize.cardRadius),
              boxShadow: [
                BoxShadow(
                  color: SColors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Present
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: SColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: SSize.sm),
                    Text(
                      '$presentCount Present',
                      style: TextStyle(
                        color: SColors.success,
                        fontWeight: FontWeight.bold,
                        fontSize: SSize.fontSizeMd,
                      ),
                    ),
                  ],
                ),
                // Absent
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: SColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: SSize.sm),
                    Text(
                      '$absentCount Absent',
                      style: TextStyle(
                        color: SColors.error,
                        fontWeight: FontWeight.bold,
                        fontSize: SSize.fontSizeMd,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: SSize.spaceBtwItems),

          // Submit/Update Button
          SizedBox(
            width: double.infinity,
            height: SSize.buttonHeight,
            child: ElevatedButton(
              onPressed: () {
                Get.snackbar(
                  isEditing ? 'Updated' : 'Success',
                  isEditing
                      ? 'Attendance updated successfully!'
                      : 'Attendance submitted successfully!',
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 2),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isEditing ? Colors.amber : SColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
                ),
              ),
              child: Text(
                isEditing ? 'Update Attendance' : 'Submit Attendance',
                style: TextStyle(
                  color: isEditing ? SColors.textPrimary : SColors.white,
                  fontSize: SSize.fontSizeLg,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}