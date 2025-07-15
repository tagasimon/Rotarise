import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_constants/widget_helpers.dart';
import 'package:rotaract/news_feed/models/post_model.dart';
import 'package:rotaract/news_feed/ui/news_feed_screen/widgets/post_action_widget.dart';
import 'package:rotaract/news_feed/ui/news_feed_screen/widgets/post_comments_widget.dart';
import 'package:rotaract/news_feed/ui/news_feed_screen/widgets/post_like_widget.dart';
import 'package:rotaract/news_feed/ui/news_feed_screen/widgets/post_view_widget.dart';

class PostActionsWidget extends ConsumerWidget {
  final PostModel post;
  const PostActionsWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PostLikeWidget(post: post),
        const SizedBox(width: 16),
        PostCommentsWidget(post: post),
        const SizedBox(width: 16),
        PostViewWidget(post: post),
        const Spacer(),
        // Share
        PostActionWidget(
          icon: Icons.share_outlined,
          count: null,
          onTap: () {
            if (post.content == null) return;
            WidgetHelpers.shareContent(
              content: post.content!,
              subject: 'Check out this post from Rotarise',
            );
          },
          color: Colors.grey[600]!,
        ),
      ],
    );
  }
}
