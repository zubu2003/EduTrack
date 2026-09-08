import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';

class CtMarksSummary extends StatelessWidget {
  const CtMarksSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Card 1: Best 3 Total
        Container(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Best 3 Total',
                    style: TextStyle(
                      color: SColors.white.withOpacity(0.7),
                      fontSize: SSize.fontSizeMd,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: SSize.xs),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '50',
                        style: TextStyle(
                          color: SColors.white,
                          fontSize: SSize.fontSizeXxl * 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: SSize.xs),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          '/ 60',
                          style: TextStyle(
                            color: SColors.white.withOpacity(0.6),
                            fontSize: SSize.fontSizeLg,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(SSize.sm),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
                ),
                child: Icon(
                  Icons.star_rounded,
                  color: Colors.amber,
                  size: SSize.iconLg,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: SSize.spaceBtwItems),

        // Card 2: Average Score
        Container(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Average Score',
                    style: TextStyle(
                      color: SColors.white.withOpacity(0.7),
                      fontSize: SSize.fontSizeMd,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: SSize.xs),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '16.67',
                        style: TextStyle(
                          color: SColors.white,
                          fontSize: SSize.fontSizeXxl * 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: SSize.xs),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          '/ 20',
                          style: TextStyle(
                            color: SColors.white.withOpacity(0.6),
                            fontSize: SSize.fontSizeLg,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(SSize.sm),
                decoration: BoxDecoration(
                  color: SColors.success.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
                ),
                child: Icon(
                  Icons.trending_up_rounded,
                  color: SColors.success,
                  size: SSize.iconLg,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: SSize.sm),

        // Subtitle
        Text(
          'Based on 4 Class Tests (Best 3 counted)',
          style: TextStyle(
            color: SColors.textSecondary,
            fontSize: SSize.fontSizeSm,
          ),
        ),
      ],
    );
  }
}