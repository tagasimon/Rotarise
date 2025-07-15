import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rotaract/_constants/constants.dart';
import 'package:rotaract/_core/notifiers/selected_post_notifier.dart';
import 'package:rotaract/_core/shared_widgets/circle_image_widget.dart';
import 'package:rotaract/news_feed/ui/post_details_screen/widgets/stat_item_widget.dart';

class PostContentWidget extends ConsumerWidget {
  const PostContentWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final df = DateFormat.yMMMd();
    final post = ref.watch(selectedPostNotifierProvider);
    if (post == null) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author Info
          Row(
            children: [
              CircleImageWidget(
                size: 50,
                imageUrl: post.authorAvatar ?? Constants.kDefaultImageLink,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.authorName ?? 'Unknown',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      post.clubName ?? '',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Post Content
          if (post.content != null && post.content!.isNotEmpty)
            Text(
              post.content!,
              style: const TextStyle(
                fontSize: 16,
                height: 1.4,
              ),
            ),

          const SizedBox(height: 16),

          // Post Image
          if (post.imageUrl != null)
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxHeight: 400),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  post.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.error, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Timestamp
          Text(
            df.format(post.timestamp),
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 16),

          // Stats
          Row(
            children: [
              StatItemWidget('${post.commentsCount ?? 0}', 'Comments'),
              const SizedBox(width: 24),
              StatItemWidget('${post.likesCount ?? 0}', 'Likes'),
              const SizedBox(width: 24),
              StatItemWidget('${post.viewCount}', 'Views'),
            ],
          ),
        ],
      ),
    );
  }
}
