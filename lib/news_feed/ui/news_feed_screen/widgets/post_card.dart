import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:rotaract/_constants/date_helpers.dart';
import 'package:rotaract/_constants/image_helpers.dart';
import 'package:rotaract/_core/extensions/nav_ext.dart';
import 'package:rotaract/_core/notifiers/current_user_notifier.dart';
import 'package:rotaract/_core/notifiers/selected_post_notifier.dart';
import 'package:rotaract/_core/shared_widgets/circle_image_widget.dart';
import 'package:rotaract/_core/shared_widgets/image_widget.dart';
import 'package:rotaract/news_feed/controllers/posts_controller.dart';
import 'package:rotaract/news_feed/models/post_model.dart';
import 'package:rotaract/news_feed/ui/news_feed_screen/widgets/member_by_id_widget.dart';
import 'package:rotaract/news_feed/ui/news_feed_screen/widgets/post_actions_widget.dart';
import 'package:rotaract/news_feed/ui/news_feed_screen/widgets/post_content_widget.dart';
import 'package:rotaract/news_feed/ui/post_details_screen/post_details_screen.dart';
import 'package:rotaract/news_feed/widgets/tagged_clubs_widget.dart';

class PostCard extends ConsumerStatefulWidget {
  final PostModel post;
  final int animationDelay;

  const PostCard({
    super.key,
    required this.post,
    required this.animationDelay,
  });

  @override
  ConsumerState<PostCard> createState() => PostCardState();
}

class PostCardState extends ConsumerState<PostCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool isRetweeted = false;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    Future.delayed(Duration(milliseconds: widget.animationDelay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showContextMenu(BuildContext context, TapDownDetails details,
      bool isAuthor, String postId) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        details.globalPosition,
        details.globalPosition,
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          onTap: _showReportDialog,
          value: 'report',
          child: Row(
            children: [
              Icon(Icons.flag_outlined, color: Colors.orange[600], size: 20),
              const SizedBox(width: 12),
              const Text(
                'Report',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        if (isAuthor)
          PopupMenuItem(
            onTap: () async {
              final res = await ref
                  .read(postsControllerProvider.notifier)
                  .deletePost(postId);
              if (res) {
                Fluttertoast.showToast(msg: "Deleted :)");
              }
            },
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete_outline, color: Colors.red[600], size: 20),
                const SizedBox(width: 12),
                const Text(
                  'Delete',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
      ],
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Report Post'),
          content: const Text('Are you sure you want to report this post?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle report logic here
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Post reported')),
                );
              },
              child: Text(
                'Report',
                style: TextStyle(color: Colors.orange[600]),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
        ),
        child: InkWell(
          onTap: () {
            ref
                .read(selectedPostNotifierProvider.notifier)
                .updatePost(widget.post);
            context.push(const PostDetailsScreen());
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                GestureDetector(
                  onTap: () async {
                    await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(25)),
                      ),
                      builder: (_) =>
                          MemberByIdWidget(memberId: widget.post.authorId),
                    );
                  },
                  child: CircleImageWidget(
                    imageUrl: widget.post.authorAvatar!,
                    size: 50,
                  ),
                ),
                const SizedBox(width: 12),

                // Main content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with name, handle, and time
                      Row(
                        children: [
                          Text(
                            widget.post.authorName ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            DateHelpers.formatPostTimestamp(
                                widget.post.timestamp),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 15,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTapDown: (details) async {
                              final cUser =
                                  ref.read(currentUserNotifierProvider);
                              _showContextMenu(
                                  context,
                                  details,
                                  cUser!.id == widget.post.authorId,
                                  widget.post.id);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                Icons.more_horiz,
                                color: Colors.grey[600],
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        widget.post.clubName ?? "",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Post content with clickable links, expandable text, and copy functionality
                      PostContentWidget(
                        content: widget.post.content ?? "",
                        isExpanded: isExpanded,
                        onSeeMoreTapped: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                      ),

                      // Media
                      if (widget.post.imageUrl != null) ...[
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () => ImageHelpers.showFullScreenImage(
                              context, widget.post.imageUrl!),
                          child: Hero(
                            tag: 'image_${widget.post.id}',
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: ImageWidget(
                                    imageUrl: widget.post.imageUrl!,
                                    size: Size(size.width * 0.7, 300),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],

                      if (widget.post.videoUrl != null) ...[
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () => ImageHelpers.showFullScreenVideo(
                              context, widget.post.videoUrl!),
                          child: Hero(
                            tag: 'video_${widget.post.id}',
                            child: Container(
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[900],
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Icon(
                                      Icons.videocam,
                                      size: 40,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.play_arrow,
                                      size: 24,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],

                      // Tagged clubs
                      if (widget.post.taggedClubIds != null &&
                          widget.post.taggedClubIds!.isNotEmpty)
                        TaggedClubsWidget(
                            taggedClubIds: widget.post.taggedClubIds!),

                      // Action buttons
                      const SizedBox(height: 12),
                      PostActionsWidget(post: widget.post)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
