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
import 'package:rotaract/news_feed/widgets/mention_text_field.dart';
import 'package:rotaract/news_feed/widgets/tagged_clubs_widget.dart';

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

class _CreatePostModalState extends ConsumerState<CreatePostModal>
    with SingleTickerProviderStateMixin {
  // State variables
  bool _hasSelectedImage = false;
  bool _isCreatingPost = false;
  String? _selectedImagePath;
  Uint8List? _selectedImageBytes;
  PlatformFile? _selectedPlatformFile;
  List<String> _taggedClubIds = [];

  // Animation controller for smooth interactions
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                _buildHandle(),
                _buildHeader(),
                const Divider(height: 1),
                _buildContent(),
              ],
            ),
          ),
        );
      },
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

  Widget _buildHeader() {
    // Watch only loading states we need
    final uploadImageState = ref.watch(
        uploadImageControllerProvider.select((state) => state.isLoading));
    final postsState =
        ref.watch(postsControllerProvider.select((state) => state.isLoading));
    final isLoading = _isCreatingPost || uploadImageState || postsState;

    final hasContent =
        widget.controller.text.trim().isNotEmpty || _hasSelectedImage;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          TextButton(
            onPressed: isLoading ? null : _handleCancel,
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
          _PostButton(
            hasContent: hasContent,
            isLoading: isLoading,
            onPressed: _handleCreatePost,
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    // Only watch the imageUrl from currentUser
    final currentUserImageUrl = ref.watch(
      currentUserNotifierProvider.select((user) => user?.imageUrl),
    );

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _UserInputSection(
              controller: widget.controller,
              userImageUrl: currentUserImageUrl,
              hasSelectedImage: _hasSelectedImage,
              onTextChanged: () => setState(() {}),
              onMentionsChanged: (taggedIds) {
                setState(() {
                  _taggedClubIds = taggedIds;
                });
              },
            ),
            if (_hasSelectedImage)
              _ImagePreview(
                selectedImagePath: _selectedImagePath,
                selectedImageBytes: _selectedImageBytes,
                onRemove: _removeSelectedImage,
              ),
            if (_taggedClubIds.isNotEmpty)
              TaggedClubsWidget(taggedClubIds: _taggedClubIds),
            const Spacer(),
            _MediaOptionsSection(
              hasSelectedImage: _hasSelectedImage,
              onSelectImage: _selectImage,
            ),
          ],
        ),
      ),
    );
  }

  void _handleCancel() {
    _animationController.reverse().then((_) {
      if (mounted) Navigator.of(context).pop();
    });
  }

  Future<void> _selectImage() async {
    if (_isCreatingPost) return;

    try {
      final controller = ref.read(uploadImageControllerProvider.notifier);
      final pickedFile = await controller.pickImageFile();

      if (pickedFile != null && mounted) {
        setState(() {
          _hasSelectedImage = true;
          _selectedImagePath = pickedFile.path;
          _selectedPlatformFile = pickedFile;
        });

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
      _selectedPlatformFile = null;
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
      taggedClubIds: _taggedClubIds.isNotEmpty ? _taggedClubIds : null,
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
      _animationController.reverse().then((_) {
        if (mounted) Navigator.of(context).pop();
      });
    }
  }

  void _resetForm() {
    widget.controller.clear();
    _removeSelectedImage();
    setState(() {
      _taggedClubIds = [];
    });
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

// Separate widgets for better performance
class _PostButton extends StatelessWidget {
  final bool hasContent;
  final bool isLoading;
  final VoidCallback onPressed;

  const _PostButton({
    required this.hasContent,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (hasContent && !isLoading) ? onPressed : null,
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Text('Post'),
    );
  }
}

class _UserInputSection extends StatelessWidget {
  final TextEditingController controller;
  final String? userImageUrl;
  final bool hasSelectedImage;
  final VoidCallback onTextChanged;
  final Function(List<String>)? onMentionsChanged;

  const _UserInputSection({
    required this.controller,
    required this.userImageUrl,
    required this.hasSelectedImage,
    required this.onTextChanged,
    this.onMentionsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleImageWidget(
          imageUrl: userImageUrl ?? Constants.kDefaultImageLink,
          size: 50,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: MentionTextField(
            controller: controller,
            maxLines: hasSelectedImage ? 4 : 8,
            hintText: "What's on your mind?",
            onTextChanged: onTextChanged,
            onMentionsChanged: onMentionsChanged,
          ),
        ),
      ],
    );
  }
}

class _ImagePreview extends StatelessWidget {
  final String? selectedImagePath;
  final Uint8List? selectedImageBytes;
  final VoidCallback onRemove;

  const _ImagePreview({
    required this.selectedImagePath,
    required this.selectedImageBytes,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _buildImage(),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: onRemove,
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
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (kIsWeb && selectedImageBytes != null) {
      return Image.memory(
        selectedImageBytes!,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else if (selectedImagePath != null) {
      return Image.file(
        File(selectedImagePath!),
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }
    return const SizedBox.shrink();
  }
}

class _MediaOptionsSection extends StatelessWidget {
  final bool hasSelectedImage;
  final VoidCallback onSelectImage;

  const _MediaOptionsSection({
    required this.hasSelectedImage,
    required this.onSelectImage,
  });

  @override
  Widget build(BuildContext context) {
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
            isSelected: hasSelectedImage,
            onTap: onSelectImage,
          ),
        ],
      ),
    );
  }
}
