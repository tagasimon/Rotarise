import 'dart:ui';

extension ColorOpacity on Color {
  Color opacity(double opacity) {
    // Fixed: Use the new Color API
    return Color.fromARGB(
      (opacity * 255).round(),
      (r * 255).round(),
      (g * 255).round(),
      (b * 255).round(),
    );
  }

  // Fixed: Create withAlpha without using deprecated withOpacity
  Color withAlphaa(double opacity) {
    return Color.fromARGB(
      (opacity * 255).round(),
      (r * 255).round(),
      (g * 255).round(),
      (b * 255).round(),
    );
  }

  // Additional helper methods for common opacity values
  Color get lighter => opacity(0.1);
  Color get light => opacity(0.3);
  Color get semi => opacity(0.5);
  Color get dark => opacity(0.7);
  Color get darker => opacity(0.9);
}
