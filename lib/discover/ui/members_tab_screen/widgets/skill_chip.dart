import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/extensions/color_extension.dart';

class SkillChip extends ConsumerWidget {
  final String label;
  final Color accentColor;
  const SkillChip({super.key, required this.label, required this.accentColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accentColor.withAlphaa(0.1),
            accentColor.withAlphaa(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: accentColor.withAlphaa(0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: accentColor.withAlphaa(0.8),
        ),
      ),
    );
  }
}
