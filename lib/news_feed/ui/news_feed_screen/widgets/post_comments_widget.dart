import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/extensions/nav_ext.dart';
import 'package:rotaract/_core/notifiers/selected_post_notifier.dart';
import 'package:rotaract/news_feed/models/post_model.dart';
import 'package:rotaract/news_feed/ui/news_feed_screen/widgets/post_action_widget.dart';
import 'package:rotaract/news_feed/ui/post_details_screen/post_details_screen.dart';

class PostCommentsWidget extends ConsumerWidget {
  final PostModel post;
  const PostCommentsWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PostActionWidget(
      icon: Icons.comment,
      count: post.commentsCount,
      onTap: () {
        ref.read(selectedPostNotifierProvider.notifier).updatePost(post);
        context.push(const PostDetailsScreen());
      },
      color: Colors.grey[600]!,
      isActive: false,
    );
  }
}
