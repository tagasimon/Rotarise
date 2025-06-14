import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/notifiers/club_tab_notifier.dart';
import 'package:rotaract/_core/notifiers/selected_club_notifier.dart';
import 'package:rotaract/discover/ui/discover_screen/widgets/stat_card_widget.dart';

class StatsSectionWidget extends ConsumerWidget {
  const StatsSectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cClub = ref.watch(selectedClubNotifierProvider);
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: StatCardWidget(
                onTap: () {
                  ref.read(clubTabIndexProvider.notifier).setTabIndex(0);
                },
                number: "${cClub?.membersCount ?? 0}",
                label: "Members",
                icon: Icons.group,
                color: Colors.purple.shade400,
              ),
            ),
            _buildStatDivider(),
            Expanded(
              child: StatCardWidget(
                onTap: () {
                  ref.read(clubTabIndexProvider.notifier).setTabIndex(1);
                },
                number: "${cClub?.eventsCount ?? 0}",
                label: "Events",
                icon: Icons.event,
                color: Colors.green.shade400,
              ),
            ),
            _buildStatDivider(),
            Expanded(
              child: StatCardWidget(
                onTap: () {
                  ref.read(clubTabIndexProvider.notifier).setTabIndex(2);
                },
                number: "${cClub?.projectsCount ?? 0}",
                label: "Projects",
                icon: Icons.work_outline, // Changed icon for better distinction
                color: Colors
                    .orange.shade400, // Changed color for better distinction
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey.shade200,
      margin: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
