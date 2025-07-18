import 'package:flutter/material.dart';
import '../molecules/card_header.dart';
import '../molecules/qr_code_section.dart';
import '../molecules/member_info_footer.dart';

class QRMembershipCard extends StatelessWidget {
  final String membershipData;
  final String memberId;
  final String membershipStatus;
  final Color statusColor;
  final String title;
  final String subtitle;
  final Color headerColor;
  final double qrSize;

  const QRMembershipCard({
    super.key,
    required this.membershipData,
    required this.memberId,
    this.membershipStatus = 'Active Membership',
    this.statusColor = Colors.green,
    this.title = 'Your QR Membership',
    this.subtitle = 'Show this code for check-in',
    this.headerColor = Colors.blue,
    this.qrSize = 280,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CardHeader(
            title: title,
            subtitle: subtitle,
            backgroundColor: headerColor,
          ),
          QRCodeSection(data: membershipData, qrSize: qrSize),
          MemberInfoFooter(
            memberId: memberId,
            membershipStatus: membershipStatus,
            statusColor: statusColor,
          ),
        ],
      ),
    );
  }
}
