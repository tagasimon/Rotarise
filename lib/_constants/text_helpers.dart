import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rotaract/_constants/widget_helpers.dart';

class TextHelpers {
  static List<TextSpan> buildPostTextSpans(String text) {
    final List<TextSpan> spans = [];
    final RegExp urlRegex = RegExp(
      r'https?://[^\s]+|www\.[^\s]+|[a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9]*\.([a-zA-Z]{2,})[^\s]*',
      caseSensitive: false,
    );

    int lastMatchEnd = 0;

    for (final match in urlRegex.allMatches(text)) {
      // Add text before the URL
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: const TextStyle(color: Colors.black),
        ));
      }

      // Add the clickable URL
      final url = match.group(0)!;
      spans.add(TextSpan(
        text: url,
        style: TextStyle(
          color: Colors.blue[600],
          decoration: TextDecoration.underline,
          decorationColor: Colors.blue[600],
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () async {
            await WidgetHelpers.llaunchUrl(url);
          },
      ));

      lastMatchEnd = match.end;
    }

    // Add remaining text after the last URL
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd),
        style: const TextStyle(color: Colors.black),
      ));
    }

    // If no URLs were found, return the entire text
    if (spans.isEmpty) {
      spans.add(TextSpan(
        text: text,
        style: const TextStyle(color: Colors.black),
      ));
    }

    return spans;
  }
}
