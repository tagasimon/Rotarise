import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_network/image_network.dart';
import 'package:rotaract/_constants/image_helpers.dart';
import 'package:share_plus/share_plus.dart';

import 'package:rotaract/_constants/constants.dart';
import 'package:rotaract/_constants/date_helpers.dart';
import 'package:rotaract/_constants/widget_helpers.dart';
import 'package:rotaract/_core/shared_widgets/club_name_by_id_widget.dart';
import 'package:rotaract/_core/shared_widgets/image_widget.dart';
import 'package:rotaract/discover/ui/events_tab_screen/models/club_event_model.dart';

class EventItemWidget extends ConsumerStatefulWidget {
  final ClubEventModel event;
  final int animationDelay;

  const EventItemWidget({
    super.key,
    required this.event,
    this.animationDelay = 0,
  });

  @override
  ConsumerState<EventItemWidget> createState() => _EventItemWidgetState();
}

class _EventItemWidgetState extends ConsumerState<EventItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    Future.delayed(Duration(milliseconds: widget.animationDelay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showEventOptions(BuildContext context, TapDownDetails details) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        details.globalPosition,
        details.globalPosition,
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          value: 'share',
          child: Row(
            children: [
              Icon(Icons.share_outlined, color: Colors.blue[600], size: 20),
              const SizedBox(width: 12),
              const Text('Share Event', style: TextStyle(fontSize: 14)),
            ],
          ),
          onTap: () async {
            await Share.share(
              'Check out this Event: ${widget.event.title}\n\nDownload the app: ${Constants.kAppLink}',
              subject: 'Rotaract Event',
            );
          },
        ),
        PopupMenuItem(
          value: 'save',
          child: Row(
            children: [
              Icon(Icons.bookmark_outline, color: Colors.green[600], size: 20),
              const SizedBox(width: 12),
              const Text('Save Event', style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ],
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.event.imageUrl ?? Constants.kDefaultImageLink;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        margin: const EdgeInsets.only(bottom: 1),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
        ),
        child: InkWell(
          onTap: () {
            // Handle event tap - navigate to event details
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with title and options
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.event.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          ClubNameByIdWidget(clubId: widget.event.clubId),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTapDown: (details) =>
                          _showEventOptions(context, details),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.more_horiz,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Event details
                GestureDetector(
                  onTap: () async {
                    await DateHelpers.addToCalendar(
                      title: 'Workshop',
                      start: DateTime(2024, 7, 15, 10, 0),
                      end: DateTime(2024, 7, 15, 12, 0),
                      description: 'Flutter development workshop',
                      location: 'Online',
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: Colors.blue.shade600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          DateHelpers.formatEventDate(
                              widget.event.startDate, widget.event.endDate),
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.green.shade600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          WidgetHelpers.launchDirections(widget.event.location);
                        },
                        child: Text(
                          widget.event.location,
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Event image
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    ImageHelpers.showFullScreenImage(context, imageUrl);
                  },
                  child: Hero(
                    tag: 'event_image_${widget.event.id}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Stack(
                            children: [
                              ImageWidget(
                                imageUrl: imageUrl,
                                size: const Size(double.infinity, 300),
                                boxFitMobile: BoxFit.cover,
                                boxFitWeb: BoxFitWeb.cover,
                              ),
                              // Fullscreen indicator
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(
                                    Icons.fullscreen,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// TODO Implement Event Actions
                // const SizedBox(height: 12),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     EventActionButton(
                //       icon: Icons.person_add_outlined,
                //       label: 'Interested',
                //       onTap: () {
                //         // Handle interested action
                //         // TODO implement this
                //       },
                //     ),
                //     EventActionButton(
                //       icon: Icons.share_outlined,
                //       label: 'Share',
                //       onTap: () {
                //         // Handle share action
                //         // TODO Implement this
                //       },
                //     ),
                //   ],
                // ),
