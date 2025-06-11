import 'package:flutter/material.dart';
import 'package:rotaract/_constants/constants.dart';
import 'package:rotaract/_core/shared_widgets/image_widget.dart';

class NewsTabWidget extends StatelessWidget {
  const NewsTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 6, // Mock data
        itemBuilder: (context, index) => _buildNewsCard(index),
      ),
    );
  }

  Widget _buildNewsCard(int index) {
    final mockNews = [
      {
        'title': 'New Rotaract Club Chartered in Jinja',
        'summary':
            'The newest addition to the Rotaract family was officially chartered last week...',
        'date': '2 days ago',
        'category': 'Club News',
        'image':
            'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?w=400',
      },
      {
        'title': 'Annual District Conference Announced',
        'summary':
            'Mark your calendars for the upcoming district conference featuring...',
        'date': '1 week ago',
        'category': 'Events',
        'image':
            'https://images.unsplash.com/photo-1511578314322-379afb476865?w=400',
      },
    ];

    final news = mockNews[index % mockNews.length];

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
      child: Row(
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.horizontal(left: Radius.circular(16)),
            child: ImageWidget(
              imageUrl: news["image"] ?? Constants.kDefaultImageLink,
              size: const Size(100, 100),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      news['category']!,
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    news['title']!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    news['summary']!,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    news['date']!,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
