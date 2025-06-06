import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/notifiers/discover_tab_index_notifier.dart';
import 'package:rotaract/discover/ui/discover_screen/widgets/stat_card_widget.dart';
import 'package:rotaract/discover/ui/events_screen/providers/club_events_providers.dart';

class EventsCountWidget extends ConsumerWidget {
  const EventsCountWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countProv = ref.watch(getTotalEventsCountProvider);
    return GestureDetector(
      onTap: () {
        ref.read(discoverTabIndexProvider.notifier).setTabIndex(1);
      },
      child: countProv.when(data: (count) {
        return StatCardWidget(
            number: "$count",
            label: "Events",
            icon: Icons.event,
            color: Colors.green.shade400);
      }, error: (e, s) {
        return StatCardWidget(
            number: "_",
            label: "Events",
            icon: Icons.groups_outlined,
            color: Colors.blue.shade400);
      }, loading: () {
        return StatCardWidget(
            number: "...",
            label: "Events",
            icon: Icons.event,
            color: Colors.blue.shade400);
      }),
    );
  }
}
