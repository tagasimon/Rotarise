import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/extensions/extensions.dart';
import 'package:rotaract/_core/notifiers/selected_post_notifier.dart';
import 'package:rotaract/news_feed/models/post_model.dart';
import 'package:rotaract/news_feed/providers/posts_providers.dart';
import 'package:rotaract/news_feed/ui/post_details_screen/post_details_screen.dart';
import 'package:rotaract/news_feed/ui/news_feed_screen/widgets/post_action_widget.dart';

class PostCommentsWidget extends ConsumerWidget {
  final PostModel post;
  const PostCommentsWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentsCountProv = ref.watch(postCommentsCountProvider);
    return commentsCountProv.when(
      data: (data) {
        return PostActionWidget(
          icon: Icons.comment,
          count: data ?? 0,
          onTap: () {
            ref.read(selectedPostNotifierProvider.notifier).updatePost(post);
            context.push(const PostDetailsScreen());
          },
          color: Colors.grey[600]!,
        );
      },
      loading: () {
        return PostActionWidget(
          icon: Icons.comment,
          count: post.commentsCount ?? 0,
          onTap: () {
            ref.read(selectedPostNotifierProvider.notifier).updatePost(post);
            context.push(const PostDetailsScreen());
          },
          color: Colors.grey[600]!,
        );
      },
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
