import 'package:flutter/material.dart';
import '../atoms/qr_code_display.dart';

class QRCodeSection extends StatelessWidget {
  final String data;
  final double qrSize;

  const QRCodeSection({super.key, required this.data, this.qrSize = 280});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: QRCodeDisplay(data: data, size: qrSize),
        ),
      ),
    );
  }
}
