import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_constants/constants.dart';
import 'package:rotaract/_core/extensions/color_extension.dart';
import 'package:rotaract/_core/notifiers/current_user_notifier.dart';
import 'package:rotaract/_core/shared_widgets/circle_image_widget.dart';
import 'package:rotaract/news_feed/ui/news_feed_screen/widgets/create_post_modal.dart';

class CreatePostSliverSection extends ConsumerWidget {
  const CreatePostSliverSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: RepaintBoundary(
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withAlphaa(0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlphaa(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // User Avatar - Fixed: Remove redundant ref parameter
              const _UserAvatar(),

              const SizedBox(width: 12),

              // Input Field
              Expanded(
                child: _CreatePostInput(
                  onTap: () => _showCreatePostModal(context),
                ),
              ),

              const SizedBox(width: 8),

              // Add Button
              _AddPostButton(
                onTap: () => _showCreatePostModal(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreatePostModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      useSafeArea: true,
      builder: (context) => CreatePostModal(
        controller: TextEditingController(), // Provide required controller
        onPostCreated: () {
          // Optionally refresh feed here
        },
      ),
    );
  }
}

// Fixed: Remove redundant ref parameter
class _UserAvatar extends ConsumerWidget {
  const _UserAvatar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cUser = ref.watch(currentUserNotifierProvider.select(
      (user) => user?.imageUrl,
    ));

    return CircleImageWidget(
      imageUrl: cUser ?? Constants.kDefaultImageLink,
      size: 44,
    );
  }
}

// Separate widget for input field
class _CreatePostInput extends StatelessWidget {
  final VoidCallback onTap;

  const _CreatePostInput({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: theme.colorScheme.outline.withAlphaa(0.3),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "What's on your mind?",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withAlphaa(0.6),
                  fontSize: 15,
                ),
              ),
            ),
            Icon(
              Icons.edit_outlined,
              color: theme.colorScheme.onSurface.withAlphaa(0.4),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

// Separate widget for add button
class _AddPostButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddPostButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.primaryColor.withAlphaa(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Icons.add_circle_outline,
            color: theme.primaryColor,
            size: 24,
          ),
        ),
      ),
    );
  }
}
