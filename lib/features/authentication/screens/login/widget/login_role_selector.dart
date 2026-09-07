import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class LoginRoleSelector extends StatelessWidget {
  const LoginRoleSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: SColors.grey.withOpacity(0.15),
        borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
      ),
      child: Row(
        children: [
          // Student Button (Selected)
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: SSize.sm),
              decoration: BoxDecoration(
                color: SColors.white,
                borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
                boxShadow: [
                  BoxShadow(
                    color: SColors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'Student',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: SColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: SSize.fontSizeMd,
                ),
              ),
            ),
          ),

          // Teacher Button (Unselected)
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: SSize.sm),
              decoration: BoxDecoration(
                color: SColors.transparent,
                borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
              ),
              child: Text(
                'Teacher',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: SColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: SSize.fontSizeMd,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}