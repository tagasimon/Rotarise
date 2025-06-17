import 'package:flutter/material.dart';
import 'package:rotaract/discover/ui/events_screen/models/club_event_model.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final ClubEventModel event;
  final VoidCallback onConfirm;

  const DeleteConfirmationDialog({
    super.key,
    required this.event,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Event'),
      content: Text(
          'Are you sure you want to delete "${event.title}"? This action cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
