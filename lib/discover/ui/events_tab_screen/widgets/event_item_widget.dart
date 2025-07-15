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

                // Event details container
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      // Date and time
                      GestureDetector(
                        onTap: () async {
                          await DateHelpers.addToCalendar(
                            title: widget.event.title,
                            start: widget.event.startDate as DateTime,
                            end: widget.event.endDate as DateTime,
                            description: 'Event: ${widget.event.title}',
                            location: widget.event.location,
                          );
                        },
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.calendar_today_outlined,
                                size: 18,
                                color: Colors.blue.shade600,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Event Date',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    DateHelpers.formatEventDate(
                                        widget.event.startDate,
                                        widget.event.endDate),
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade600,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Add to Calendar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Location/Event type
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: widget.event.isOnline
                                  ? Colors.purple.shade50
                                  : Colors.green.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              widget.event.isOnline
                                  ? Icons.computer_outlined
                                  : Icons.location_on_outlined,
                              size: 18,
                              color: widget.event.isOnline
                                  ? Colors.purple.shade600
                                  : Colors.green.shade600,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.event.isOnline
                                      ? 'Online Event'
                                      : 'Location',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                GestureDetector(
                                  onTap: () {
                                    if (widget.event.isOnline &&
                                        widget.event.eventLink != null) {
                                      WidgetHelpers.llaunchUrl(
                                          widget.event.eventLink!);
                                    } else if (!widget.event.isOnline) {
                                      WidgetHelpers.launchDirections(
                                          widget.event.location);
                                    }
                                  },
                                  child: Text(
                                    widget.event.isOnline
                                        ? (widget.event.eventLink != null
                                            ? 'Join Event'
                                            : 'Online')
                                        : widget.event.location,
                                    style: TextStyle(
                                      color: widget.event.isOnline
                                          ? Colors.purple.shade700
                                          : Colors.green.shade700,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      decoration: (widget.event.isOnline &&
                                                  widget.event.eventLink !=
                                                      null) ||
                                              !widget.event.isOnline
                                          ? TextDecoration.underline
                                          : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (widget.event.isOnline)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.purple.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'ONLINE',
                                style: TextStyle(
                                  color: Colors.purple,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),

                      // Payment information
                      if (widget.event.isPaid) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.payment_outlined,
                                size: 18,
                                color: Colors.orange.shade600,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Event Fee',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    widget.event.amount != null
                                        ? '\$${widget.event.amount!.toStringAsFixed(2)}'
                                        : 'Paid Event',
                                    style: TextStyle(
                                      color: Colors.orange.shade700,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'PAID',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.celebration_outlined,
                                size: 18,
                                color: Colors.green.shade600,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Free Event',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'FREE',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
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
