import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rotaract/_constants/constants.dart';
import 'package:rotaract/_core/shared_widgets/club_info_widget.dart';
import 'package:rotaract/discover/ui/events_screen/models/club_event_model.dart';

class EventItemWidget extends ConsumerWidget {
  final ClubEventModel event;
  const EventItemWidget({super.key, required this.event});

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black87,
      builder: (context) => Dialog.fullscreen(
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
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                    errorWidget: (context, url, error) => Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.error_outline,
                              size: 48, color: Colors.white70),
                          SizedBox(height: 8),
                          Text('Failed to load image',
                              style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
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
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startDate =
        DateFormat('dd MMM yyyy').format(event.startDate as DateTime);
    final endDate = DateFormat('dd MMM yyyy').format(event.endDate as DateTime);
    final imageUrl = event.imageUrl ?? Constants.kDefaultImageLink;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: GestureDetector(
              onTap: () => _showFullScreenImage(context, imageUrl),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: imageUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Container(
                      height: 160,
                      color: Colors.grey.shade200,
                      child:
                          const Icon(Icons.event, size: 40, color: Colors.grey),
                    ),
                  ),
                  // Optional: Add a subtle overlay to indicate it's tappable
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(4),
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined,
                        size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      "$startDate - $endDate",
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined,
                        size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      event.location,
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [ClubInfoWidget(clubId: event.clubId)],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// > trading businesses
// > operates on tally

// > can tally get online
// > transactions are decentralised
// > can get on tally remotely

// >> Step 1: get it in the cloud
// >> Step 2: get various people to post
// >> Step 3: add more modules
// >>
