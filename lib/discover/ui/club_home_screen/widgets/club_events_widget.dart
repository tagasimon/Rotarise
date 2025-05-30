import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/discover/ui/events_screen/providers/club_events_providers.dart';
import 'package:rotaract/discover/ui/events_screen/widgets/event_item_widget.dart';

class ClubEventsWidget extends ConsumerWidget {
  final String clubId;
  const ClubEventsWidget({super.key, required this.clubId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsProvider = ref.watch(clubEventsByClubIdProvider(clubId));
    return eventsProvider.when(
      data: (events) {
        return Container(
          margin: const EdgeInsets.only(top: 20),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: events.length,
            itemBuilder: (context, index) =>
                EventItemWidget(event: events[index]),
            physics: const BouncingScrollPhysics(),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
