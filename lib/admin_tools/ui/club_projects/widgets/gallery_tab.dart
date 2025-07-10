import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/extensions/color_extension.dart';
import 'package:rotaract/_core/shared_widgets/image_widget.dart';

class GalleryTab extends ConsumerWidget {
  const GalleryTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaItems = [
      {
        'type': 'image',
        'url':
            'https://images.unsplash.com/photo-1497486751825-1233686d5d80?w=400'
      },
      {
        'type': 'image',
        'url':
            'https://images.unsplash.com/photo-1541888946425-d81bb19240f5?w=400'
      },
      {
        'type': 'video',
        'url':
            'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=400'
      },
      {
        'type': 'image',
        'url': 'https://images.unsplash.com/photo-1559136555-9303baea8ebd?w=400'
      },
      {
        'type': 'image',
        'url':
            'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=400'
      },
      {
        'type': 'video',
        'url':
            'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?w=400'
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1,
        ),
        itemCount: mediaItems.length,
        itemBuilder: (context, index) {
          final item = mediaItems[index];
          return GestureDetector(
            onTap: () => _showMediaViewer(context, item, mediaItems, index),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlphaa(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ImageWidget(
                      imageUrl: item['url']!,
                      size: const Size(50, 50),
                    ),
                    if (item['type'] == 'video')
                      Container(
                        color: Colors.black.withAlphaa(0.3),
                        child: const Center(
                          child: Icon(
                            Icons.play_circle_outline,
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showMediaViewer(BuildContext context, Map<String, dynamic> item,
      List<Map<String, dynamic>> items, int index) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ImageWidget(
                    imageUrl: item['url']!,
                    size: const Size(50, 50),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white, size: 32),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
