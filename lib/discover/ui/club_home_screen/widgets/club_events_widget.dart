import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/discover/ui/events_tab_screen/providers/club_events_providers.dart';
import 'package:rotaract/discover/ui/events_tab_screen/widgets/event_item_widget.dart';

class ClubEventsWidget extends ConsumerWidget {
  const ClubEventsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsProvider = ref.watch(eventsByClubIdProvider);

    return eventsProvider.when(
      data: (events) {
        if (events.isEmpty) {
          return const Center(child: Text("No Events"));
        }

        return CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: EventItemWidget(event: events[index]),
                ),
                childCount: events.length,
              ),
            )
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
