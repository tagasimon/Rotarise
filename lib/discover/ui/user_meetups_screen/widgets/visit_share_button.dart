import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rotaract/_constants/widget_helpers.dart';
import 'package:rotaract/discover/models/visit_model.dart';

class VisitShareButton extends StatelessWidget {
  final VisitModel visit;

  const VisitShareButton({super.key, required this.visit});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _shareVisit(visit),
        icon: const Icon(Icons.share),
        label: const Text('Share Visit'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  void _shareVisit(VisitModel visit) {
    final shareText =
        'I visited ${visit.visitedClubName} on ${DateFormat('MMM dd, yyyy').format(visit.visitDate)}! ${visit.visitDesc}';
    WidgetHelpers.shareContent(content: shareText);
  }
}
