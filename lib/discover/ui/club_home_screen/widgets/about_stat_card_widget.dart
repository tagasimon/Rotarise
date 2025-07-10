import 'package:flutter/material.dart';
import 'package:rotaract/_core/extensions/color_extension.dart';

class AboutStatCardWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const AboutStatCardWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withAlphaa(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withAlphaa(0.1)),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.blue,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
