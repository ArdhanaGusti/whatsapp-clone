import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_front_end/styles/style.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool filled;
  final double minWidth;
  const CustomButton({super.key, required this.text, required this.onPressed, this.filled = true, this.minWidth = double.infinity});

  @override
  Widget build(BuildContext context) {
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;
    final borderRadius = BorderRadius.circular(12);

    if (isIos) {
      return SizedBox(
        width: minWidth == double.infinity ? double.infinity : minWidth,
        child: CupertinoButton(
          padding: const EdgeInsets.symmetric(vertical: 14),
          color: filled ? AppColors.primary : null,
          borderRadius: borderRadius,
          child: Text(text, style: TextStyle(color: filled ? Colors.white : AppColors.primary)),
          onPressed: onPressed,
        ),
      );
    }

    return SizedBox(
      width: minWidth == double.infinity ? double.infinity : minWidth,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: filled ? AppColors.primary : Colors.transparent,
          elevation: filled ? 2 : 0,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: borderRadius, side: filled ? BorderSide.none : BorderSide(color: AppColors.primary)),
        ),
        child: Text(text, style: TextStyle(color: filled ? Colors.white : AppColors.primary)),
      ),
    );
  }
}
