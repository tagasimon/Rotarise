// Extracted into separate widget for better performance
import 'package:flutter/material.dart';
import 'package:rotaract/_constants/constants.dart';
import 'package:rotaract/_constants/image_helpers.dart';
import 'package:rotaract/_core/shared_widgets/circle_image_widget.dart';
import 'package:rotaract/discover/ui/events_tab_screen/models/club_event_model.dart';

class EventCard extends StatelessWidget {
  final ClubEventModel event; // Replace with your Event model type

  const EventCard({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        onTap: () async {
          if (event.imageUrl == null) return;
          ImageHelpers.showFullScreenImage(context, event.imageUrl!);
        },
        child: Container(
          width: 90,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Event Image Circle with better caching
              SizedBox(
                width: 64,
                height: 64,
                child: CircleImageWidget(
                  imageUrl: event.imageUrl ?? Constants.kDefaultImageLink,
                  size: 64,
                  // Add these if your CircleImageWidget supports them
                  // cacheWidth: 128,
                  // cacheHeight: 128,
                ),
              ),
              const SizedBox(height: 8),
              // Event Title with better text handling
              Flexible(
                child: Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                    height: 1.2, // Better line height
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
