import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/news_feed/models/post_model.dart';
import 'package:rotaract/news_feed/ui/news_feed_screen/widgets/post_action_widget.dart';
import 'package:rotaract/news_feed/ui/news_feed_screen/widgets/post_comments_widget.dart';
import 'package:rotaract/news_feed/ui/news_feed_screen/widgets/post_like_widget.dart';

class PostActionsWidget extends ConsumerWidget {
  final PostModel post;
  const PostActionsWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PostCommentsWidget(post: post),
        PostLikeWidget(post: post),

        // Share
        PostActionWidget(
          icon: Icons.share_outlined,
          count: null,
          onTap: () {},
          color: Colors.grey[600]!,
        ),
      ],
    );
  }
}
