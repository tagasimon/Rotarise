import 'package:flutter/material.dart';
import 'package:rotaract/_core/extensions/color_extension.dart';
import 'package:rotaract/discover/models/visit_model.dart';
import 'package:rotaract/discover/ui/user_meetups_screen/widgets/stat_item_widget.dart';

class VisitsStatsHeader extends StatelessWidget {
  final List<VisitModel> visits;

  const VisitsStatsHeader({super.key, required this.visits});

  @override
  Widget build(BuildContext context) {
    final totalVisits = visits.length;
    final uniqueClubs = visits.map((v) => v.visitedClubId).toSet().length;
    final thisYear = DateTime.now().year;
    final thisYearVisits =
        visits.where((v) => v.visitDate.year == thisYear).length;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade600,
            Colors.purple.shade600,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withAlphaa(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            '🎉 Your Visit Journey',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StatItemWidget(
                label: 'Total Visits',
                value: totalVisits.toString(),
                emoji: '📍',
              ),
              StatItemWidget(
                label: 'Unique Clubs',
                value: uniqueClubs.toString(),
                emoji: '🏢',
              ),
              StatItemWidget(
                label: 'This Year',
                value: thisYearVisits.toString(),
                emoji: '📅',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
