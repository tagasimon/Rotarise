import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rotaract/discover/models/visit_model.dart';
import 'package:rotaract/discover/ui/user_meetups_screen/widgets/empty_state_widget.dart';
import 'package:rotaract/discover/ui/user_meetups_screen/widgets/month_section_widget.dart';
import 'package:rotaract/discover/ui/user_meetups_screen/widgets/visits_stat_header.dart';

class VisitsContentWidget extends StatelessWidget {
  final List<VisitModel> visits;

  const VisitsContentWidget({super.key, required this.visits});

  @override
  Widget build(BuildContext context) {
    if (visits.isEmpty) {
      return const EmptyStateWidget();
    }

    // Sort visits by date (most recent first)
    visits.sort((a, b) => b.visitDate.compareTo(a.visitDate));

    // Group visits by month/year for better organization
    final groupedVisits = _groupVisitsByMonth(visits);

    return CustomScrollView(
      slivers: [
        // Statistics Header
        SliverToBoxAdapter(
          child: VisitsStatsHeader(visits: visits),
        ),

        // Visits Timeline
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final monthKey = groupedVisits.keys.elementAt(index);
                final monthVisits = groupedVisits[monthKey]!;
                return MonthSectionWidget(
                  monthKey: monthKey,
                  visits: monthVisits,
                );
              },
              childCount: groupedVisits.length,
            ),
          ),
        ),
      ],
    );
  }

  Map<String, List<VisitModel>> _groupVisitsByMonth(List<VisitModel> visits) {
    final grouped = <String, List<VisitModel>>{};

    for (final visit in visits) {
      final monthKey = DateFormat('MMMM yyyy').format(visit.visitDate);
      grouped.putIfAbsent(monthKey, () => []).add(visit);
    }

    return grouped;
  }
}
