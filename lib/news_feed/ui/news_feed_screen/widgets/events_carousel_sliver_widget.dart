import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/discover/ui/events_tab_screen/providers/club_events_providers.dart';
import 'package:rotaract/news_feed/ui/news_feed_screen/widgets/event_card.dart';

class EventsCarouselSliverWidget extends ConsumerWidget {
  const EventsCarouselSliverWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsProv = ref.watch(allEventsProvider);

    return eventsProv.when(
      data: (data) {
        if (data.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }

        // Limit to first 10 events for better performance
        final limitedEvents = data.take(10).toList();

        return SliverToBoxAdapter(
          child: RepaintBoundary(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 1),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      'Upcoming Events',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: limitedEvents.length,
                      // Add cache extent for better scrolling
                      cacheExtent: 200,
                      itemBuilder: (context, index) {
                        final event = limitedEvents[index];
                        return EventCard(
                          key:
                              ValueKey(event.id), // Add key for better rebuilds
                          event: event,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => SliverToBoxAdapter(child: SizedBox.shrink()),
      error: (_, __) => SliverToBoxAdapter(child: SizedBox.shrink()),
    );
  }
}
