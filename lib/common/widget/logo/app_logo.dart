import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:edutrack/utils/constant/image_string.dart';

class SAppLogo extends StatelessWidget {
  final double? size;
  final bool showText;

  const SAppLogo({
    super.key,
    this.size,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // App Icon/Logo
        Container(
          width: size ?? 80,
          height: size ?? 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image(image: AssetImage(SImages.appLogoIconLight),)
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