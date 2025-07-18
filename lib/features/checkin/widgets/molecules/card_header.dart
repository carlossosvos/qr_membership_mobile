import 'package:flutter/material.dart';
import '../../../../core/widgets/atoms/app_text.dart';

class CardHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final double borderRadius;

  const CardHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.backgroundColor = Colors.blue,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
        ),
      ),
      child: Column(
        children: [
          AppText(
            text: title,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          const SizedBox(height: 4),
          AppText(text: subtitle, fontSize: 14, color: Colors.white70),
        ],
      ),
    );
  }
}
