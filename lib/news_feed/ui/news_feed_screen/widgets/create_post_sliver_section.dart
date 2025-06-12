import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_constants/constants.dart';
import 'package:rotaract/_core/notifiers/current_user_notifier.dart';
import 'package:rotaract/_core/shared_widgets/circle_image_widget.dart';
import 'package:rotaract/news_feed/ui/news_feed_screen/widgets/create_post_modal.dart';

class CreatePostSliverSection extends ConsumerStatefulWidget {
  const CreatePostSliverSection({super.key});

  @override
  ConsumerState<CreatePostSliverSection> createState() =>
      _CreatePostSectionState();
}

class _CreatePostSectionState extends ConsumerState<CreatePostSliverSection> {
  final TextEditingController _postController = TextEditingController();

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cUser = ref.watch(currentUserNotifierProvider);
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            ProfessionalCircleImageWidget(
              imageUrl: cUser?.imageUrl == null
                  ? Constants.kDefaultImageLink
                  : cUser!.imageUrl!,
              size: 50,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: _showCreatePostModal,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Text(
                    "What's on your mind?",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _showCreatePostModal,
              icon: Icon(
                Icons.add_circle,
                color: Theme.of(context).primaryColor,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreatePostModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreatePostModal(
        controller: _postController,
        // onPost: _handleNewPost,
        // onPost: (a, b, c) {
        //   // TODO Implement this
        // },
      ),
    );
  }
}
