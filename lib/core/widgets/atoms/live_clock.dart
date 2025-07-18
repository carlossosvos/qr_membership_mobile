import 'package:flutter/material.dart';
import 'app_text.dart';

class LiveClock extends StatefulWidget {
  final TextStyle? timeStyle;
  final TextStyle? dateStyle;
  final CrossAxisAlignment alignment;
  final bool showSeconds;
  final bool showDate;

  const LiveClock({
    super.key,
    this.timeStyle,
    this.dateStyle,
    this.alignment = CrossAxisAlignment.start,
    this.showSeconds = true,
    this.showDate = true,
  });

  @override
  State<LiveClock> createState() => _LiveClockState();
}

class _LiveClockState extends State<LiveClock> {
  late Stream<DateTime> _timeStream;

  @override
  void initState() {
    super.initState();
    _timeStream = Stream.periodic(
      const Duration(seconds: 1),
      (_) => DateTime.now(),
    );
  }

  String _formatTime(DateTime time) {
    if (widget.showSeconds) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
    } else {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }

  String _formatDate(DateTime time) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return '${days[time.weekday - 1]}, ${months[time.month - 1]} ${time.day}';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime>(
      stream: _timeStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final now = snapshot.data!;
        return Column(
          crossAxisAlignment: widget.alignment,
          children: [
            // Time display
            AppText(
              text: _formatTime(now),
              style:
                  widget.timeStyle ??
                  TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade600,
                  ),
            ),

            // Date display (if enabled)
            if (widget.showDate) ...[
              const SizedBox(height: 2),
              AppText(
                text: _formatDate(now),
                style:
                    widget.dateStyle ??
                    TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ],
        );
      },
    );
  }
}
