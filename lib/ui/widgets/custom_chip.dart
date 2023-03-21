import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  static const Color approvedTextColor = Color(0xff027A48);
  static const Color approvedBackgroundColor = Color(0xffECFDF3);
  static const Color pendingTextColor = Color(0xff026AA2);
  static const Color pendingBackgroundColor = Color(0xffF0F9FF);
  static const Color rejectedTextColor = Color(0xffC01048);
  static const Color rejectedBackgroundColor = Color(0xffFFF1F3);

  final String text;
  final Color textColor;
  final Color backgroundColor;

  const CustomChip.user({super.key, required this.text})
      : textColor = pendingTextColor,
        backgroundColor = pendingBackgroundColor;

  const CustomChip.pending({super.key})
      : text = 'Pending',
        textColor = pendingTextColor,
        backgroundColor = pendingBackgroundColor;

  const CustomChip.approved({super.key})
      : text = 'Approved',
        textColor = approvedTextColor,
        backgroundColor = approvedBackgroundColor;

  const CustomChip.rejected({super.key})
      : text = 'Rejected',
        textColor = rejectedTextColor,
        backgroundColor = rejectedBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: Chip(
        label: Text(text),
        labelStyle: TextStyle(color: textColor),
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.only(bottom: 8),
      ),
    );
  }
}
