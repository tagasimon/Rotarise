import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_constants/constants.dart';
import 'package:rotaract/_core/notifiers/current_user_notifier.dart';
import 'package:rotaract/_core/notifiers/selected_post_notifier.dart';
import 'package:rotaract/news_feed/controllers/comments_controller.dart';
import 'package:rotaract/news_feed/models/comment_model.dart';
import 'package:uuid/uuid.dart';

class CommentInputWidget extends ConsumerStatefulWidget {
  const CommentInputWidget({super.key});

  @override
  ConsumerState<CommentInputWidget> createState() => _CommentInputWidgetState();
}

class _CommentInputWidgetState extends ConsumerState<CommentInputWidget> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(commentsControllerProvider);
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey, width: 0.2)),
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + 8,
      ),
      child: SafeArea(
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(
                ref.read(currentUserNotifierProvider)?.imageUrl ??
                    Constants.kDefaultImageLink,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _commentController,
                focusNode: _commentFocusNode,
                decoration: const InputDecoration(
                  hintText: 'Add a comment...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: _submitComment,
                maxLines: null,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: state.isLoading
                  ? null
                  : () => _submitComment(_commentController.text),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _commentController.text.trim().isEmpty
                      ? Colors.grey[300]
                      : Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: state.isLoading
                    ? const CircularProgressIndicator()
                    : Icon(
                        Icons.add,
                        size: 16,
                        color: _commentController.text.trim().isEmpty
                            ? Colors.grey[600]
                            : Colors.white,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitComment(String text) async {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty) return;

    final currentUser = ref.read(currentUserNotifierProvider);
    final post = ref.read(selectedPostNotifierProvider);
    if (currentUser == null || post == null) return;

    final comment = CommentModel(
      id: const Uuid().v4(),
      postId: post.id,
      userId: currentUser.id,
      comment: trimmedText,
      date: DateTime.now(),
      userName: "${currentUser.firstName} ${currentUser.lastName}",
      userAvatarUrl: currentUser.imageUrl ?? Constants.kDefaultImageLink,
    );

    await ref.read(commentsControllerProvider.notifier).addComment(comment);

    _commentController.clear();
    _commentFocusNode.unfocus();
  }
}
