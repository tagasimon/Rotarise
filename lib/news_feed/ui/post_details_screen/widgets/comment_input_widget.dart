import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_constants/constants.dart';
import 'package:rotaract/_core/extensions/color_extension.dart';
import 'package:rotaract/_core/notifiers/current_user_notifier.dart';
import 'package:rotaract/_core/notifiers/selected_post_notifier.dart';
import 'package:rotaract/_core/shared_widgets/circle_image_widget.dart';
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
    final theme = Theme.of(context);
    final isEnabled =
        !state.isLoading && _commentController.text.trim().isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: theme.dividerColor.withAlphaa(0.3),
            width: 0.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlphaa(0.05),
            offset: const Offset(0, -1),
            blurRadius: 4,
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 12,
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CircleImageWidget(
              imageUrl: ref.read(currentUserNotifierProvider)?.imageUrl ??
                  Constants.kDefaultImageLink,
              size: 36,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 120),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.dividerColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _commentController,
                  focusNode: _commentFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Write a comment...',
                    hintStyle: TextStyle(
                      color:
                          theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14),
                  textInputAction: TextInputAction.send,
                  onSubmitted: _submitComment,
                  onChanged: (_) =>
                      setState(() {}), // Trigger rebuild for button state
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ),
            const SizedBox(width: 12),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isEnabled
                      ? () => _submitComment(_commentController.text)
                      : null,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isEnabled
                          ? theme.primaryColor
                          : theme.disabledColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: state.isLoading
                        ? Padding(
                            padding: const EdgeInsets.all(10),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.send_rounded,
                            size: 20,
                            color: isEnabled
                                ? theme.colorScheme.onPrimary
                                : theme.disabledColor,
                          ),
                  ),
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

    // Clear the input immediately for better UX
    _commentController.clear();
    _commentFocusNode.unfocus();

    // Trigger rebuild to update button state
    setState(() {});

    final comment = CommentModel(
      id: const Uuid().v4(),
      postId: post.id,
      userId: currentUser.id,
      comment: trimmedText,
      date: DateTime.now(),
      userName: "${currentUser.firstName} ${currentUser.lastName}",
      userAvatarUrl: currentUser.imageUrl ?? Constants.kDefaultImageLink,
    );

    try {
      await ref.read(commentsControllerProvider.notifier).addComment(comment);
    } catch (e) {
      // If there's an error, restore the text and show feedback
      if (mounted) {
        _commentController.text = trimmedText;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to post comment. Please try again.'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Theme.of(context).colorScheme.onError,
              onPressed: () => _submitComment(trimmedText),
            ),
          ),
        );
      }
    }
  }
}
