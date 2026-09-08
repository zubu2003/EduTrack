import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class STeacherInfoWidget extends StatelessWidget {
  final String teacherName;
  final double? avatarRadius;
  final double? fontSize;
  final bool showIcon;

  const STeacherInfoWidget({
    super.key,
    required this.teacherName,
    this.avatarRadius,
    this.fontSize,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showIcon) ...[
          CircleAvatar(
            radius: avatarRadius ?? 14,
            backgroundColor: SColors.primary.withOpacity(0.1),
            child: Icon(
              Icons.person_outline,
              color: SColors.primary,
              size: (avatarRadius ?? 14) * 1.2,
            ),
          ),
          const SizedBox(width: SSize.xs),
        ],
        Text(
          teacherName,
          style: TextStyle(
            color: SColors.textSecondary,
            fontSize: fontSize ?? SSize.fontSizeMd,
          ),
        ),
      ],
    );
  }
}