import 'package:flutter/material.dart';
import 'package:rotaract/_core/extensions/color_extension.dart';

class GradientOverlayWidget extends StatelessWidget {
  const GradientOverlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withAlphaa(0.3),
            Colors.black.withAlphaa(0.7),
          ],
        ),
      ),
    );
  }
}
