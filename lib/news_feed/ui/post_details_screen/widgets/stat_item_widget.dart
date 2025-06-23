import 'package:flutter/material.dart';

class StatItemWidget extends StatelessWidget {
  final String count;
  final String label;
  const StatItemWidget(this.count, this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: count,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          TextSpan(
            text: ' $label',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
