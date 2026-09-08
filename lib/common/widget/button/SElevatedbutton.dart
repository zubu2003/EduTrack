
import 'package:flutter/material.dart';

import '../../../utils/constant/colors.dart';
import '../../../utils/constant/size.dart';

class SElevatedbutton extends StatelessWidget {
  const SElevatedbutton({
    super.key, required this.onPressed, required this.text,
  });

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: SColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SSize.buttonRadius),
        ),
        elevation: 0,
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}