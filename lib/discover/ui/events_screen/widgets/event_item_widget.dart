import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_network/image_network.dart';
import 'package:intl/intl.dart';
import 'package:rotaract/_constants/constants.dart';
import 'package:rotaract/_core/shared_widgets/club_name_by_id_widget.dart';
import 'package:rotaract/_core/shared_widgets/image_widget.dart';
import 'package:rotaract/discover/ui/events_screen/models/club_event_model.dart';

class EventItemWidget extends ConsumerWidget {
  final ClubEventModel event;
  const EventItemWidget({super.key, required this.event});

  void _showFullScreenImage(BuildContext context, String imageUrl, Size size) {
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
                  child: ImageWidget(
                    imageUrl: imageUrl,
                    size: Size(size.height * 0.8, size.height * 0.7),
                    boxFitMobile: BoxFit.fitWidth,
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
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startDate =
        DateFormat('dd MMM yyyy').format(event.startDate as DateTime);
    final endDate = DateFormat('dd MMM yyyy').format(event.endDate as DateTime);
    final imageUrl = event.imageUrl ?? Constants.kDefaultImageLink;
    final size = MediaQuery.of(context).size;
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
              onTap: () => _showFullScreenImage(context, imageUrl, size),
              child: Stack(
                children: [
                  ImageWidget(
                    imageUrl: imageUrl,
                    size: Size(size.width * 0.9, 250),
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
                    GestureDetector(
                      onTap: () async {
                        // TODO Fix this
                        //                       final encodedLocation = Uri.encodeComponent(locationName);

                        // final url = kIsWeb
                        //     ? Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$encodedLocation')
                        //     : Uri.parse('google.navigation:q=$encodedLocation');

                        // if (await canLaunchUrl(url)) {
                        //   await launchUrl(url, mode: LaunchMode.externalApplication);
                        // } else {
                        //   throw 'Could not launch $url';
                        // }
                      },
                      child: Text(
                        event.location,
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClubNameByIdWidget(clubId: event.clubId)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
