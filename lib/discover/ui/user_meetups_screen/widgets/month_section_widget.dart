import 'package:flutter/material.dart';
import 'package:rotaract/discover/models/visit_model.dart';
import 'package:rotaract/discover/ui/user_meetups_screen/widgets/visit_card_widget.dart';

class MonthSectionWidget extends StatelessWidget {
  final String monthKey;
  final List<VisitModel> visits;

  const MonthSectionWidget({
    super.key,
    required this.monthKey,
    required this.visits,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  monthKey,
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${visits.length} visit${visits.length == 1 ? '' : 's'}',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        ...visits.map((visit) => VisitCardWidget(visit: visit)),
        const SizedBox(height: 16),
      ],
    );
  }
}
