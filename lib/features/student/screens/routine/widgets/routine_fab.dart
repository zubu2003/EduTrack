import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:iconsax/iconsax.dart';

class RoutineFAB extends StatelessWidget {
  final VoidCallback onPressed;

  const RoutineFAB({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: SColors.primary,
      elevation: 4,
      child: const Icon(
        Iconsax.add,
        color: SColors.white,
        size: SSize.iconMd,
      ),
    );
  }
}