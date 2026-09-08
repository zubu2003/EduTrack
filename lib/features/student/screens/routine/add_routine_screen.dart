import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/common/widget/appbar/common_appbar.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class AddRoutineScreen extends StatelessWidget {
  final String day;
  final Map<String, dynamic>? routine;
  final int index;

  const AddRoutineScreen({
    super.key,
    this.day = 'Sun',
    this.routine,
    this.index = -1,
  });

  @override
  Widget build(BuildContext context) {
    final isEditing = routine != null;

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
              // Title
              Text(
                isEditing ? 'Edit Routine' : 'Add New Routine',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: SColors.textPrimary,
                ),
              ),
              const SizedBox(height: SSize.spaceBtwItems),

              // Day Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: SSize.md),
                decoration: BoxDecoration(
                  color: SColors.white,
                  borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
                  border: Border.all(
                    color: SColors.grey.withOpacity(0.3),
                  ),
                ),
                child: DropdownButtonFormField<String>(
                  value: day,
                  decoration: const InputDecoration(
                    labelText: 'Day',
                    prefixIcon: Icon(Iconsax.calendar, color: SColors.grey),
                    border: InputBorder.none,
                  ),
                  items: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu'].map((day) {
                    return DropdownMenuItem(value: day, child: Text(day));
                  }).toList(),
                  onChanged: (value) {},
                  icon: const Icon(Icons.keyboard_arrow_down, color: SColors.grey),
                ),
              ),

              const SizedBox(height: SSize.spaceBtwItems),

              // Start Time
              Container(
                padding: const EdgeInsets.all(SSize.md),
                decoration: BoxDecoration(
                  color: SColors.white,
                  borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
                  border: Border.all(
                    color: SColors.grey.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Iconsax.clock, color: SColors.grey),
                    const SizedBox(width: SSize.spaceBtwItems),
                    Text(
                      'Start Time: ${routine?['startTime'] ?? '10:00 AM'}',
                      style: TextStyle(
                        color: SColors.textPrimary,
                        fontSize: SSize.fontSizeMd,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.keyboard_arrow_down, color: SColors.grey),
                  ],
                ),
              ),

              const SizedBox(height: SSize.spaceBtwItems),

              // End Time
              Container(
                padding: const EdgeInsets.all(SSize.md),
                decoration: BoxDecoration(
                  color: SColors.white,
                  borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
                  border: Border.all(
                    color: SColors.grey.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Iconsax.clock, color: SColors.grey),
                    const SizedBox(width: SSize.spaceBtwItems),
                    Text(
                      'End Time: ${routine?['endTime'] ?? '11:00 AM'}',
                      style: TextStyle(
                        color: SColors.textPrimary,
                        fontSize: SSize.fontSizeMd,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.keyboard_arrow_down, color: SColors.grey),
                  ],
                ),
              ),

              const SizedBox(height: SSize.spaceBtwItems),

              // Course Code
              TextFormField(
                initialValue: routine?['courseCode'] ?? '',
                decoration: InputDecoration(
                  labelText: 'Course Code',
                  hintText: 'e.g. CSE 356',
                  prefixIcon: const Icon(Iconsax.code, color: SColors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
                    borderSide: BorderSide(
                      color: SColors.grey.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
                    borderSide: const BorderSide(color: SColors.primary),
                  ),
                ),
              ),

              const SizedBox(height: SSize.spaceBtwItems),

              // Course Name
              TextFormField(
                initialValue: routine?['courseName'] ?? '',
                decoration: InputDecoration(
                  labelText: 'Course Name',
                  hintText: 'e.g. Advanced AI Principles',
                  prefixIcon: const Icon(Iconsax.book, color: SColors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
                    borderSide: BorderSide(
                      color: SColors.grey.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
                    borderSide: const BorderSide(color: SColors.primary),
                  ),
                ),
              ),

              const SizedBox(height: SSize.spaceBtwItems),

              // Room
              TextFormField(
                initialValue: routine?['room'] ?? '',
                decoration: InputDecoration(
                  labelText: 'Room',
                  hintText: 'e.g. Room 301',
                  prefixIcon: const Icon(Iconsax.location, color: SColors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
                    borderSide: BorderSide(
                      color: SColors.grey.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
                    borderSide: const BorderSide(color: SColors.primary),
                  ),
                ),
              ),

              const SizedBox(height: SSize.spaceBtwItems),

              // Teacher
              TextFormField(
                initialValue: routine?['teacher'] ?? '',
                decoration: InputDecoration(
                  labelText: 'Teacher',
                  hintText: 'e.g. Dr. Alan T.',
                  prefixIcon: const Icon(Iconsax.user, color: SColors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
                    borderSide: BorderSide(
                      color: SColors.grey.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
                    borderSide: const BorderSide(color: SColors.primary),
                  ),
                ),
              ),

              const SizedBox(height: SSize.spaceBtwSections),

              // Save Button (UI Only - No Functionality)
              SizedBox(
                width: double.infinity,
                height: SSize.buttonHeight,
                child: ElevatedButton(
                  onPressed: () {
                    Get.snackbar(
                      'Coming Soon',
                      'Save functionality will be added later',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 2),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
                    ),
                  ),
                  child: Text(
                    isEditing ? 'Update Routine' : 'Save Routine',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: SColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}