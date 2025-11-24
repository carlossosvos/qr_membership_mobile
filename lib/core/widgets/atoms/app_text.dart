import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final TextStyle? style;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;

  const AppText({
    super.key,
    required this.text,
    this.textAlign,
    this.style,
    this.color,
    this.fontSize,
    this.fontWeight,
  });

  const AppText.body({
    super.key,
    required this.text,
    this.textAlign,
    this.style,
  }) : color = null,
       fontSize = 14,
       fontWeight = null;

  const AppText.caption({
    super.key,
    required this.text,
    this.textAlign,
    this.style,
  }) : color = null,
       fontSize = 12,
       fontWeight = null;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
          style ??
          TextStyle(
            fontSize: fontSize ?? 14,
            color: color ?? Colors.grey.shade600,
            fontWeight: fontWeight,
          ),
      textAlign: textAlign ?? TextAlign.center,
    );
  }
}
