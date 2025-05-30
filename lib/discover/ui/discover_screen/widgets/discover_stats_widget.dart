import 'package:flutter/material.dart';
import 'package:rotaract/discover/ui/club_home_screen/widgets/clubs_count_widget.dart';
import 'package:rotaract/discover/ui/club_home_screen/widgets/events_count_widget.dart';
import 'package:rotaract/discover/ui/discover_screen/widgets/stat_card_widget.dart';

class DiscoverStatsWidget extends StatelessWidget {
  const DiscoverStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Expanded(child: ClubsCountWidget()),
          const Expanded(child: EventsCountWidget()),
          Expanded(
            // TODO Fix this
            child: StatCardWidget(
                number: "_",
                label: "Projects",
                icon: Icons.handshake_outlined,
                color: Colors.orange.shade400),
          ),
        ],
      ),
    );
  }
}
