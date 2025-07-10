import 'package:flutter/material.dart';
import 'package:rotaract/_core/extensions/color_extension.dart';

class PostActionWidget extends StatelessWidget {
  final IconData icon;
  final int? count;
  final VoidCallback onTap;
  final Color color;
  final bool isActive;
  const PostActionWidget({
    super.key,
    required this.icon,
    required this.count,
    required this.onTap,
    required this.color,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isActive ? color.withAlphaa(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                // size: 18,
                color: color,
              ),
            ),
            if (count != null && count! > 0) ...[
              const SizedBox(width: 4),
              Text(
                count.toString(),
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
