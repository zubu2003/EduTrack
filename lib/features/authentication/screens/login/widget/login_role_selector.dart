import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

import '../../../controllers/login/login_controller.dart';

class LoginRoleSelector extends StatelessWidget {
  const LoginRoleSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: SColors.grey.withOpacity(0.15),
        borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
      ),
      child: Obx(
            () => Row(
          children: [
            // Student Button
            Expanded(
              child: GestureDetector(
                onTap: () => controller.selectRole('Student'),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: SSize.sm),
                  decoration: BoxDecoration(
                    color: controller.selectedRole.value == 'Student'
                        ? SColors.white
                        : SColors.transparent,
                    borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
                    boxShadow: controller.selectedRole.value == 'Student'
                        ? [
                      BoxShadow(
                        color: SColors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ]
                        : null,
                  ),
                  child: Text(
                    'Student',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: controller.selectedRole.value == 'Student'
                          ? SColors.primary
                          : SColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: SSize.fontSizeMd,
                    ),
                  ),
                ),
              ),
            ),

            // Teacher Button
            Expanded(
              child: GestureDetector(
                onTap: () => controller.selectRole('Teacher'),

                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: SSize.sm),
                  decoration: BoxDecoration(
                    color: controller.selectedRole.value == 'Teacher'
                        ? SColors.white
                        : SColors.transparent,
                    borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
                    boxShadow: controller.selectedRole.value == 'Teacher'
                        ? [
                      BoxShadow(
                        color: SColors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ]
                        : null,
                  ),
                  child: Text(
                    'Teacher',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: controller.selectedRole.value == 'Teacher'
                          ? SColors.primary
                          : SColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: SSize.fontSizeMd,
                    ),
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