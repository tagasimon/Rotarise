import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/news_feed/models/post_model.dart';
import 'package:rotaract/news_feed/ui/news_feed_screen/widgets/post_action_widget.dart';

class PostViewWidget extends ConsumerWidget {
  final PostModel post;
  const PostViewWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PostActionWidget(
      icon: Icons.bar_chart_rounded,
      count: post.viewCount,
      onTap: () {
        // Views are typically read-only, so no action needed
        // Could potentially show view details or analytics here
      },
      color: Colors.grey[600]!,
      isActive: false,
    );
  }
}
