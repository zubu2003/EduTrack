import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:edutrack/utils/constant/colors.dart';

class SShimmer extends StatelessWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration period;

  const SShimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.period = const Duration(milliseconds: 1400),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? SColors.lightGrey,
      highlightColor: highlightColor ?? SColors.white,
      period: period,
      child: child,
    );
  }
}

class SShimmerBox extends StatelessWidget {
  final double? width;
  final double height;
  final BorderRadius borderRadius;

  const SShimmerBox({
    super.key,
    this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: SColors.grey,
        borderRadius: borderRadius,
      ),
    );
  }
}
