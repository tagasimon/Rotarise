import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rotaract/_constants/widget_helpers.dart';
import 'package:rotaract/discover/models/visit_model.dart';
import 'package:rotaract/discover/ui/user_meetups_screen/widgets/detail_row.dart';

class VisitDetailsInfo extends StatelessWidget {
  final VisitModel visit;

  const VisitDetailsInfo({super.key, required this.visit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DetailRow(
          icon: Icons.calendar_today,
          label: 'Visit Date',
          value: DateFormat('EEEE, MMMM dd, yyyy').format(visit.visitDate),
        ),
        if (visit.visitDesc.isNotEmpty) ...[
          const SizedBox(height: 16),
          DetailRow(
            icon: Icons.description,
            label: 'Description',
            value: visit.visitDesc,
          ),
        ],
        if (visit.latitude != null && visit.longitude != null) ...[
          const SizedBox(height: 16),
          DetailRow(
            icon: Icons.location_on,
            label: 'Location',
            value:
                'Lat: ${visit.latitude!.toStringAsFixed(6)}, Lng: ${visit.longitude!.toStringAsFixed(6)}',
            actionIcon: Icons.directions,
            onAction: () => WidgetHelpers.launchDirections(
              '${visit.latitude},${visit.longitude}',
            ),
          ),
        ],
      ],
    );
  }
}
