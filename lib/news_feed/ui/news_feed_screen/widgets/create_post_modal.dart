import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rotaract/_constants/constants.dart';
import 'package:rotaract/_core/notifiers/current_user_notifier.dart';
import 'package:rotaract/admin_tools/providers/club_repo_providers.dart';
import 'package:rotaract/news_feed/controllers/posts_controller.dart';
import 'package:rotaract/news_feed/models/post_model.dart';
import 'package:rotaract/news_feed/ui/news_feed_screen/widgets/media_option.dart';
import 'package:uuid/uuid.dart';

class CreatePostModal extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final Function(String, String?) onPost;

  const CreatePostModal({
    super.key,
    required this.controller,
    required this.onPost,
  });

  @override
  ConsumerState<CreatePostModal> createState() => CreatePostModalState();
}

class CreatePostModalState extends ConsumerState<CreatePostModal> {
  String? selectedMediaType;
  bool _isPosting = false;

  Future<void> _handlePost() async {
    if (widget.controller.text.isEmpty || _isPosting) return;

    setState(() {
      _isPosting = true;
    });

    try {
      final cUser = ref.watch(currentUserNotifierProvider);
      if (cUser == null || cUser.clubId == null) {
        Fluttertoast.showToast(msg: "You don't belong to a Club");
        return;
      }
      // final clubInfoProv = ref.watch(getEventClubByIdProvider(clubId));
      final club =
          await ref.watch(getEventClubByIdProvider(cUser.clubId!).future);
      if (club == null) {
        Fluttertoast.showToast(msg: "Error!!!");
        return;
      }
      final post = PostModel(
        id: const Uuid().v4(),
        authorId: cUser.id,
        clubId: cUser.clubId!,
        clubName: club.name,
        authorName: "${cUser.firstName} ${cUser.lastName}",
        authorAvatar: cUser.imageUrl ?? Constants.kDefaultImageLink,
        content: widget.controller.text.trim(),
        timestamp: DateTime.now(),
      );

      final res =
          await ref.read(postsControllerProvider.notifier).addPost(post);

      if (res) {
        // Call the onPost callback with content and media type
        widget.onPost(widget.controller.text.trim(), selectedMediaType);

        // Show success message
        Fluttertoast.showToast(msg: "Post created successfully!");

        // Close the modal
        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        Fluttertoast.showToast(msg: "Failed to create post. Please try again.");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "An error occurred. Please try again.");
    } finally {
      if (mounted) {
        setState(() {
          _isPosting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cUser = ref.watch(currentUserNotifierProvider);
    final state = ref.watch(postsControllerProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                TextButton(
                  onPressed: _isPosting ? null : () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const Spacer(),
                const Text(
                  'Create Post',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: (widget.controller.text.isNotEmpty && !_isPosting)
                      ? _handlePost
                      : null,
                  child: _isPosting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Post'),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Content
          if (state.isLoading || _isPosting) const LinearProgressIndicator(),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: cUser?.imageUrl == null
                            ? const NetworkImage(
                                Constants.kDefaultImageLink,
                              )
                            : NetworkImage(cUser!.imageUrl!),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: widget.controller,
                          maxLines: 8,
                          enabled: !_isPosting,
                          decoration: const InputDecoration(
                            hintText: "What's on Your Mind?",
                            border: InputBorder.none,
                            hintStyle: TextStyle(fontSize: 18),
                          ),
                          style: const TextStyle(fontSize: 16),
                          onChanged: (value) => setState(() {}),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Media options
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MediaOption(
                            icon: Icons.image,
                            label: 'Photo',
                            color: Colors.green,
                            isSelected: selectedMediaType == 'photo',
                            onTap: () {
                              Fluttertoast.showToast(
                                  msg: "Image Posting Coming Soon...");
                              //   _isPosting ? null : () => setState(() {
                              //   selectedMediaType =
                              //       selectedMediaType == 'photo' ? null : 'photo';
                              // }),
                            }),
                        MediaOption(
                            icon: Icons.videocam,
                            label: 'Video',
                            color: Colors.blue,
                            isSelected: selectedMediaType == 'video',
                            onTap: () {
                              Fluttertoast.showToast(
                                  msg: "Video Posting Coming Soon...");
                              //   _isPosting ? null : () => setState(() {
                              //   selectedMediaType =
                              //       selectedMediaType == 'video' ? null : 'video';
                              // }),
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
