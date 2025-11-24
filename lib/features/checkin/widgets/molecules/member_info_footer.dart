import 'package:flutter/material.dart';
import '../../../../core/widgets/atoms/app_text.dart';

class MemberInfoFooter extends StatelessWidget {
  final String memberId;
  final String membershipStatus;
  final Color statusColor;

  const MemberInfoFooter({
    super.key,
    required this.memberId,
    required this.membershipStatus,
    this.statusColor = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          AppText(
            text: 'Member ID: $memberId',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          const SizedBox(height: 4),
          AppText(
            text: membershipStatus,
            fontSize: 14,
            color: statusColor,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
