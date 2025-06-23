import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_network/image_network.dart';
import 'package:intl/intl.dart';
import 'package:rotaract/_constants/constants.dart';
import 'package:rotaract/_core/shared_widgets/club_name_by_id_widget.dart';
import 'package:rotaract/_core/shared_widgets/image_widget.dart';
import 'package:rotaract/discover/ui/events_screen/models/club_event_model.dart';

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

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    final size = MediaQuery.of(context).size;
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (context, animation, _) {
          return FadeTransition(
            opacity: animation,
            child: Dialog.fullscreen(
              backgroundColor: Colors.transparent,
              child: Stack(
                children: [
                  // Dismissible background
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      color: Colors.transparent,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  // Image container
                  Center(
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: InteractiveViewer(
                        panEnabled: true,
                        boundaryMargin: const EdgeInsets.all(20),
                        child: ImageWidget(
                          imageUrl: imageUrl,
                          size: Size(size.width * 0.95, size.height * 0.7),
                          boxFitMobile: BoxFit.contain,
                          boxFitWeb: BoxFitWeb.contain,
                        ),
                      ),
                    ),
                  ),
                  // Close button
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 10,
                    right: 20,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, color: Colors.white),
                        iconSize: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatEventDate(Object startDate, Object endDate) {
    // Convert Object to DateTime - they should already be DateTime from fromMap
    final DateTime start = startDate as DateTime;
    final DateTime end = endDate as DateTime;

    final startFormatted = DateFormat('dd MMM').format(start);
    final endFormatted = DateFormat('dd MMM yyyy').format(end);

    // Check if it's the same day
    if (start.year == end.year &&
        start.month == end.month &&
        start.day == end.day) {
      return DateFormat('dd MMM yyyy').format(start);
    }

    return '$startFormatted - $endFormatted';
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
                Row(
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
                        _formatEventDate(
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
                        onTap: () async {
                          // TODO: Implement location opening
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
                  onTap: () => _showFullScreenImage(context, imageUrl),
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

                // Action buttons
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildActionButton(
                      icon: Icons.person_add_outlined,
                      label: 'Interested',
                      onTap: () {
                        // Handle interested action
                        // TODO implement this
                      },
                    ),
                    _buildActionButton(
                      icon: Icons.share_outlined,
                      label: 'Share',
                      onTap: () {
                        // Handle share action
                        // TODO Implement this
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
