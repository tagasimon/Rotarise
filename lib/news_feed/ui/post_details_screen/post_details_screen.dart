import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/notifiers/selected_post_notifier.dart';
import 'package:rotaract/news_feed/ui/post_details_screen/widgets/comment_input_widget.dart';
import 'package:rotaract/news_feed/ui/post_details_screen/widgets/comments_section_widget.dart';
import 'package:rotaract/news_feed/ui/post_details_screen/widgets/post_content_widget.dart';

class PostDetailsScreen extends ConsumerWidget {
  const PostDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.read(selectedPostNotifierProvider);
    if (post == null) {
      return const Scaffold(
        body: Center(
          child: Text("Error!!"),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Post',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Post Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main Post
                  const PostContentWidget(),
                  const Divider(height: 1, thickness: 0.5),
                  // Comments Section
                  CommentsSectionWidget(),
                ],
              ),
            ),
          ),

          // Comment Input
          const CommentInputWidget(),
        ],
      ),
    );
  }
}
