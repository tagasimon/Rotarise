import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_constants/constants.dart';
import 'package:rotaract/_core/shared_widgets/circle_image_widget.dart';
import 'package:rotaract/_core/shared_widgets/image_widget.dart';
import 'package:rotaract/discover/ui/events_screen/providers/club_events_providers.dart';

class EventsCarouselSliverWidget extends ConsumerWidget {
  const EventsCarouselSliverWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final eventsProv = ref.watch(allEventsProvider);

    return eventsProv.when(
      data: (data) {
        if (data.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }
        return SliverToBoxAdapter(
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
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final event = data[index];
                      return GestureDetector(
                        onTap: () async {
                          if (event.imageUrl == null) {
                            return;
                          }

                          await showFullScreenImage(
                              event.imageUrl!, event.title, context, size);
                        },
                        child: Container(
                          width: 90,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            children: [
                              // Event Image Circle (WhatsApp Status style)
                              ProfessionalCircleImageWidget(
                                imageUrl: event.imageUrl == null
                                    ? Constants.kDefaultImageLink
                                    : event.imageUrl!,
                              ),
                              const SizedBox(height: 8),
                              // Event Title
                              Text(
                                event.title,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // const SizedBox(height: 16), // Add some bottom spacing
              ],
            ),
          ),
        );
      },
      loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
      error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
    );
  }

  Future<void> showFullScreenImage(
      String imageUrl, String title, BuildContext context, Size size) async {
    await showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 3.0,
                child: ImageWidget(
                  imageUrl: imageUrl,
                  size: Size(size.height * 0.7, size.height * 0.7),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 16,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 32,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
