import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:edutrack/utils/constant/image_string.dart';

class SAppLogo extends StatelessWidget {
  final double? size;
  final bool showText;
  final bool isCircular;

  const SAppLogo({
    super.key,
    this.size,
    this.showText = true,
    this.isCircular = false,
  });

  @override
  Widget build(BuildContext context) {
    final logoSize = size ?? 80;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // App Icon/Logo
        Container(
          width: logoSize,
          height: logoSize,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: isCircular
                ? BorderRadius.circular(logoSize / 2)
                : BorderRadius.circular(SSize.borderRadiusMd),
          ),
          child: ClipRRect(
            borderRadius: isCircular
                ? BorderRadius.circular(logoSize / 2)
                : BorderRadius.circular(SSize.borderRadiusMd),
            child: Image(
              image: AssetImage(SImages.appLogoIconLight),
              fit: BoxFit.contain,
            ),
          ),
        ),

        if (showText) ...[
          const SizedBox(height: SSize.spaceBtwItems),

          // App Name
          Text(
            'EduTrack AI',
            style: TextStyle(
              color: SColors.primary,
              fontSize: SSize.fontSizeXl,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ],
    );
  }
}