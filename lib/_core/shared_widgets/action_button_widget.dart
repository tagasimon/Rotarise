import 'package:flutter/material.dart';
import 'package:rotaract/_core/extensions/color_extension.dart';

class ActionButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLight;
  final IconData icon;
  const ActionButtonWidget({
    super.key,
    required this.icon,
    required this.onPressed,
    this.isLight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isLight ? Colors.black.light : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isLight
            ? null
            : [
                BoxShadow(
                  color: Colors.black.lighter,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: isLight ? Colors.white : Colors.grey.shade700,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
