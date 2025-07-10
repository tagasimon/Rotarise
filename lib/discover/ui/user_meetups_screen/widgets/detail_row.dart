import 'package:flutter/material.dart';

class DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final IconData? actionIcon;
  final VoidCallback? onAction;

  const DetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.actionIcon,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.blue.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (actionIcon != null && onAction != null)
          IconButton(
            onPressed: onAction,
            icon: Icon(actionIcon, color: Colors.blue.shade600),
          ),
      ],
    );
  }
}
