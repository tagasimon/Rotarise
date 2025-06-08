import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/discover/ui/club_home_screen/widgets/clubs_count_widget.dart';
import 'package:rotaract/discover/ui/club_home_screen/widgets/events_count_widget.dart';
import 'package:rotaract/discover/ui/club_home_screen/widgets/projects_count_widget.dart';

class DiscoverStatsWidget extends ConsumerWidget {
  const DiscoverStatsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: const Row(
        children: [
          Expanded(child: ClubsCountWidget()),
          SizedBox(width: 10),
          Expanded(child: EventsCountWidget()),
          SizedBox(width: 10),
          Expanded(child: ProjectsCountWidget()),
        ],
      ),
    );
  }
}
