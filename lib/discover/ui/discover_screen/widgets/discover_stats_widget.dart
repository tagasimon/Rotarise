import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/notifiers/discover_tab_index_notifier.dart';
import 'package:rotaract/discover/ui/club_home_screen/widgets/clubs_count_widget.dart';
import 'package:rotaract/discover/ui/club_home_screen/widgets/events_count_widget.dart';
import 'package:rotaract/discover/ui/discover_screen/widgets/stat_card_widget.dart';

class DiscoverStatsWidget extends ConsumerWidget {
  const DiscoverStatsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Expanded(child: ClubsCountWidget()),
          const SizedBox(width: 10),
          const Expanded(child: EventsCountWidget()),
          const SizedBox(width: 10),
          Expanded(
            // TODO Fix this
            child: GestureDetector(
              onTap: () {
                ref.read(discoverTabIndexProvider.notifier).setTabIndex(2);
              },
              child: StatCardWidget(
                  number: "_",
                  label: "Projects",
                  icon: Icons.handshake_outlined,
                  color: Colors.orange.shade400),
            ),
          ),
        ],
      ),
    );
  }
}
