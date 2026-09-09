import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class TeacherAIInsight extends StatelessWidget {
  const TeacherAIInsight({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SSize.md),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A1A2E),
            Color(0xFF2D2D44),
          ],
        ),
        borderRadius: BorderRadius.circular(SSize.cardRadius),
        boxShadow: [
          BoxShadow(
            color: SColors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // AI Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: SColors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
            ),
            child: const Icon(
              Iconsax.magic_star,
              color: SColors.white,
              size: SSize.iconMd,
            ),
          ),
          const SizedBox(width: SSize.spaceBtwItems),

          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Insight',
                  style: TextStyle(
                    color: SColors.white.withOpacity(0.7),
                    fontSize: SSize.fontSizeSm,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: SSize.xs),
                Text(
                  'Overall class engagement for CSE 356 has shown a 15% increase this week.',
                  style: TextStyle(
                    color: SColors.white,
                    fontSize: SSize.fontSizeMd,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}