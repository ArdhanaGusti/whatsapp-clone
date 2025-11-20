import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final bool obscureText;
  final Widget? suffixIcon;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final int? maxLines;

  const CustomTextField({
    super.key,
    this.controller,
    this.hintText = '',
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    // Use an adaptive style: Cupertino for iOS, Material for Android
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;
    final borderRadius = BorderRadius.circular(12);
    final fillColor = Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.grey[900];

    if (isIos) {
      return Container(
        decoration: BoxDecoration(color: fillColor, borderRadius: borderRadius, boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 4)),
        ]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: CupertinoTextField(
            controller: controller,
            placeholder: hintText,
            obscureText: obscureText,
            keyboardType: keyboardType,
            suffix: suffixIcon,
            prefix: prefixIcon != null ? Padding(padding: const EdgeInsets.only(right: 8.0), child: Icon(prefixIcon, size: 20)) : null,
            maxLines: maxLines,
          ),
        ),
      );
    }

    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor,
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20) : null,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide.none),
      ),
    );
  }
}
