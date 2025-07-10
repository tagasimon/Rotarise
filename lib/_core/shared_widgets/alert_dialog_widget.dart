import 'package:flutter/material.dart';
import 'package:rotaract/_core/extensions/nav_ext.dart';

class AlertDialogWidget extends StatelessWidget {
  final String title;
  final String content;
  const AlertDialogWidget({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => context.pop(false),
          child: const Text("No"),
        ),
        TextButton(
          onPressed: () => context.pop(true),
          child: const Text("Yes"),
        ),
      ],
    );
  }
}
