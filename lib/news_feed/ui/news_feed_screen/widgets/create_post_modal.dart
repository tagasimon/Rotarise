import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

import 'package:rotaract/_constants/constants.dart';
import 'package:rotaract/_core/notifiers/current_user_notifier.dart';
import 'package:rotaract/_core/notifiers/upload_image_controller.dart';
import 'package:rotaract/_core/shared_widgets/circle_image_widget.dart';
import 'package:rotaract/admin_tools/providers/club_repo_providers.dart';
import 'package:rotaract/news_feed/controllers/posts_controller.dart';
import 'package:rotaract/news_feed/models/post_model.dart';
import 'package:rotaract/news_feed/ui/news_feed_screen/widgets/media_option.dart';

class CreatePostModal extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final VoidCallback? onPostCreated;

  const CreatePostModal({
    super.key,
    required this.controller,
    this.onPostCreated,
  });

  @override
  ConsumerState<CreatePostModal> createState() => _CreatePostModalState();
}

class _CreatePostModalState extends ConsumerState<CreatePostModal> {
  bool _hasSelectedImage = false;
  bool _isCreatingPost = false;
  String? _selectedImagePath;
  Uint8List? _selectedImageBytes;
  PlatformFile? _selectedPlatformFile; // Store the PlatformFile for upload

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserNotifierProvider);
    final uploadImageState = ref.watch(uploadImageControllerProvider);
    final postsState = ref.watch(postsControllerProvider);

    final isLoading =
        _isCreatingPost || uploadImageState.isLoading || postsState.isLoading;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHandle(),
          _buildHeader(isLoading),
          const Divider(height: 1),
          _buildContent(currentUser, isLoading),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(bool isLoading) {
    final hasContent =
        widget.controller.text.trim().isNotEmpty || _hasSelectedImage;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          TextButton(
            onPressed: isLoading ? null : () => Navigator.of(context).pop(),
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
            onPressed: (hasContent && !isLoading) ? _handleCreatePost : null,
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Post'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(dynamic currentUser, bool isLoading) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildUserInputSection(currentUser, isLoading),
            if (_hasSelectedImage) _buildImagePreview(isLoading),
            const Spacer(),
            _buildMediaOptions(isLoading),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInputSection(dynamic currentUser, bool isLoading) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleImageWidget(
          imageUrl: currentUser?.imageUrl ?? Constants.kDefaultImageLink,
          size: 50,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: widget.controller,
            maxLines: _hasSelectedImage ? 4 : 8,
            enabled: !isLoading,
            decoration: const InputDecoration(
              hintText: "What's on your mind?",
              border: InputBorder.none,
              hintStyle: TextStyle(fontSize: 18),
            ),
            style: const TextStyle(fontSize: 16),
            onChanged: (_) => setState(() {}),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview(bool isLoading) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _buildPreviewImage(),
          ),
          _buildRemoveButton(isLoading),
        ],
      ),
    );
  }

  Widget _buildPreviewImage() {
    if (kIsWeb && _selectedImageBytes != null) {
      return Image.memory(
        _selectedImageBytes!,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else if (_selectedImagePath != null) {
      return Image.file(
        File(_selectedImagePath!),
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildRemoveButton(bool isLoading) {
    return Positioned(
      top: 8,
      right: 8,
      child: GestureDetector(
        onTap: isLoading ? null : _removeSelectedImage,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Colors.black54,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.close,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildMediaOptions(bool isLoading) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MediaOption(
            icon: Icons.image,
            label: 'Photo',
            color: Colors.green,
            isSelected: _hasSelectedImage,
            onTap: isLoading ? null : _selectImage,
          ),
        ],
      ),
    );
  }

  Future<void> _selectImage() async {
    if (_isCreatingPost) return;

    try {
      // Use the upload image controller to pick a file
      final controller = ref.read(uploadImageControllerProvider.notifier);
      final pickedFile = await controller.pickImageFile();

      if (pickedFile != null) {
        setState(() {
          _hasSelectedImage = true;
          _selectedImagePath = pickedFile.path;
          _selectedPlatformFile = pickedFile; // Store the PlatformFile
        });

        // For web platform, get bytes for preview
        if (kIsWeb && pickedFile.bytes != null) {
          _selectedImageBytes = pickedFile.bytes;
        }
      }
    } catch (e) {
      _showErrorToast("Failed to select image: $e");
    }
  }

  void _removeSelectedImage() {
    setState(() {
      _hasSelectedImage = false;
      _selectedImagePath = null;
      _selectedImageBytes = null;
      _selectedPlatformFile = null; // Clear the PlatformFile
    });
  }

  Future<void> _handleCreatePost() async {
    if (_isCreatingPost) return;

    final content = widget.controller.text.trim();
    if (content.isEmpty && !_hasSelectedImage) {
      _showErrorToast("Please add some content or select an image.");
      return;
    }

    setState(() => _isCreatingPost = true);

    try {
      await _createPost(content);
    } catch (e) {
      _showErrorToast("Failed to create post: $e");
    } finally {
      if (mounted) {
        setState(() => _isCreatingPost = false);
      }
    }
  }

  Future<void> _createPost(String content) async {
    final currentUser = ref.read(currentUserNotifierProvider);
    if (currentUser?.clubId == null) {
      throw Exception("You don't belong to a club");
    }

    // Get club information
    final club =
        await ref.read(getEventClubByIdProvider(currentUser!.clubId!).future);
    if (club == null) {
      throw Exception("Club not found");
    }

    // Upload image if selected
    String? imageUrl;
    if (_hasSelectedImage && _selectedPlatformFile != null) {
      imageUrl = await ref
          .read(uploadImageControllerProvider.notifier)
          .uploadImage(_selectedPlatformFile!, "POSTS");

      if (imageUrl == null) {
        throw Exception("Failed to upload image");
      }
    }

    // Create post model
    final post = PostModel(
      id: const Uuid().v4(),
      authorId: currentUser.id,
      clubId: currentUser.clubId!,
      clubName: club.name,
      authorName: "${currentUser.firstName} ${currentUser.lastName}",
      authorAvatar: currentUser.imageUrl ?? Constants.kDefaultImageLink,
      content: content,
      timestamp: DateTime.now(),
      imageUrl: imageUrl,
    );

    // Add post to repository
    final success =
        await ref.read(postsControllerProvider.notifier).addPost(post);

    if (!success) {
      throw Exception("Failed to create post");
    }

    // Success - clean up and close
    _showSuccessToast("Post created successfully!");
    _resetForm();
    widget.onPostCreated?.call();

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _resetForm() {
    widget.controller.clear();
    _removeSelectedImage();
  }

  void _showErrorToast(String message) {
    if (mounted) {
      Fluttertoast.showToast(
        msg: message,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void _showSuccessToast(String message) {
    if (mounted) {
      Fluttertoast.showToast(
        msg: message,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    }
  }
}
