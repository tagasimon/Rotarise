import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rotaract/discover/models/visit_model.dart';

class VisitInfoWidget extends StatelessWidget {
  final VisitModel visit;

  const VisitInfoWidget({super.key, required this.visit});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          visit.visitedClubName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        if (visit.visitDesc.isNotEmpty)
          Text(
            visit.visitDesc,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 14,
              color: Colors.grey.shade500,
            ),
            const SizedBox(width: 4),
            Text(
              DateFormat('MMM dd, yyyy').format(visit.visitDate),
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
              ),
            ),
            if (visit.latitude != null && visit.longitude != null) ...[
              const SizedBox(width: 12),
              Icon(
                Icons.location_on,
                size: 14,
                color: Colors.green.shade500,
              ),
            ],
          ],
        ),
      ],
    );
  }
}
