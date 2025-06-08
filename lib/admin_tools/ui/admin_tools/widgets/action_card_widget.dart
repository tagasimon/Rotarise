import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActionCardWidget extends ConsumerWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  const ActionCardWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 4,
      shadowColor: color.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16), // Reduced from 20 to 16
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // Added to minimize column size
            children: [
              Container(
                padding: const EdgeInsets.all(12), // Reduced from 16 to 12
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius:
                      BorderRadius.circular(12), // Reduced from 16 to 12
                ),
                child: Icon(
                  icon,
                  size: 28, // Reduced from 32 to 28
                  color: color,
                ),
              ),
              const SizedBox(height: 8), // Reduced from 12 to 8
              Flexible(
                // Added Flexible to prevent overflow
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15, // Reduced from 16 to 15
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1, // Limit to 1 line
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 2), // Reduced from 4 to 2
              Flexible(
                // Added Flexible to prevent overflow
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11, // Reduced from 12 to 11
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1, // Limit to 1 line
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
