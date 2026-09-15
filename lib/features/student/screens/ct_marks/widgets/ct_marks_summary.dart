import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class CtMarksSummary extends StatelessWidget {
  final double best3Total;
  final double average;
  final double percentage;
  final int bestOfCount;
  final double fullMarks;

  const CtMarksSummary({
    super.key,
    required this.best3Total,
    required this.average,
    required this.percentage,
    required this.bestOfCount,
    required this.fullMarks,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Best 3 Total Card
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
                    'Best $bestOfCount Total',
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
                        best3Total.toStringAsFixed(0),
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
                          '/ ${(fullMarks * bestOfCount).toInt()}',
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

        // Average Card
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
                        average.toStringAsFixed(2),
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
                          '/ ${fullMarks.toInt()}',
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
                padding: const EdgeInsets.symmetric(
                  horizontal: SSize.md,
                  vertical: SSize.sm,
                ),
                decoration: BoxDecoration(
                  color: SColors.success.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(SSize.borderRadiusMd),
                  border: Border.all(
                    color: SColors.success.withOpacity(0.2),
                  ),
                ),
                child: Text(
                  '${percentage.toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: SColors.success,
                    fontSize: SSize.fontSizeXxl,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: SSize.sm),

        // Subtitle
        Text(
          'Based on best $bestOfCount of all Class Tests',
          style: TextStyle(
            color: SColors.textSecondary,
            fontSize: SSize.fontSizeSm,
          ),
        ),
      ],
    );
  }
}