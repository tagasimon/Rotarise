import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class EventsTabWidget extends StatelessWidget {
  const EventsTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 5, // Mock data
        itemBuilder: (context, index) => _buildEventCard(index),
      ),
    );
  }

  Widget _buildEventCard(int index) {
    final mockEvents = [
      {
        'title': 'Community Service Day',
        'date': 'Dec 15, 2024',
        'time': '9:00 AM',
        'location': 'Central Park',
        'attendees': '45',
        'club': 'Rotaract Kampala Central',
        'image':
            'https://images.unsplash.com/photo-1559027615-cd4628902d4a?w=400',
      },
      {
        'title': 'Leadership Workshop',
        'date': 'Dec 18, 2024',
        'time': '2:00 PM',
        'location': 'Conference Hall',
        'attendees': '32',
        'club': 'Rotaract Nakawa',
        'image':
            'https://images.unsplash.com/photo-1515187029135-18ee286d815b?w=400',
      },
      // Add more mock events...
    ];

    final event = mockEvents[index % mockEvents.length];

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
            child: CachedNetworkImage(
              imageUrl: event['image']!,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Container(
                height: 160,
                color: Colors.grey.shade200,
                child: const Icon(Icons.event, size: 40, color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event['title']!,
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
                      "${event['date']} • ${event['time']}",
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
                      event['location']!,
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      event['club']!,
                      style: TextStyle(
                        color: Colors.purple.shade600,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.people_outline,
                            size: 16, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(
                          "${event['attendees']} attending",
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
