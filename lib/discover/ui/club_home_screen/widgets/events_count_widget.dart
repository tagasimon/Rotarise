import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/discover/ui/discover_screen/widgets/stat_card_widget.dart';
import 'package:rotaract/discover/ui/events_screen/providers/club_events_providers.dart';

class EventsCountWidget extends ConsumerWidget {
  const EventsCountWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countProv = ref.watch(getTotalEventsCountProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: countProv.when(
          data: (count) {
            return StatCardWidget(
                number: "$count",
                label: "Events",
                icon: Icons.event,
                color: Colors.green.shade400);
          },
          error: (e, s) => const Text("Error fetching events count"),
          loading: () {
            return StatCardWidget(
                number: "...",
                label: "Events",
                icon: Icons.event,
                color: Colors.blue.shade400);
          }),
    );
  }
}
