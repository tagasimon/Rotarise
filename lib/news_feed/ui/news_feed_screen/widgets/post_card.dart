import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rotaract/_core/notifiers/selected_post_notifier.dart';
import 'package:rotaract/news_feed/ui/news_feed_screen/widgets/post_actions_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:rotaract/_core/extensions/extensions.dart';
import 'package:rotaract/_core/notifiers/current_user_notifier.dart';
import 'package:rotaract/_core/shared_widgets/circle_image_widget.dart';
import 'package:rotaract/_core/shared_widgets/image_widget.dart';
import 'package:rotaract/news_feed/controllers/posts_controller.dart';
import 'package:rotaract/news_feed/models/post_model.dart';
import 'package:rotaract/news_feed/ui/post_details_screen/post_details_screen.dart';
import 'package:rotaract/news_feed/ui/news_feed_screen/widgets/full_screen_image_viewer.dart';
import 'package:rotaract/news_feed/ui/news_feed_screen/widgets/full_screen_video_viewer.dart';
import 'package:rotaract/news_feed/ui/news_feed_screen/widgets/member_by_id_widget.dart';

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

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      // Format as date for older posts
      return '${timestamp.day}/${timestamp.month}/${timestamp.year.toString().substring(2)}';
    }
  }

  // Function to handle URL launches
  Future<void> _launchUrl(String url) async {
    try {
      // Ensure URL has a scheme
      String formattedUrl = url;
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        formattedUrl = 'https://$url';
      }

      final Uri uri = Uri.parse(formattedUrl);

      bool canLaunch = await canLaunchUrl(uri);

      if (canLaunch) {
        bool launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );

        if (!launched) {
          throw Exception('Failed to launch URL');
        }
      } else {
        throw Exception('Cannot launch URL');
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Could not open link: $url",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  Widget _buildPostContent() {
    final content = widget.post.content ?? "";

    if (content.isEmpty) {
      return const SizedBox.shrink();
    }

    final shouldTruncate = content.length > 100;
    final displayText =
        shouldTruncate && !isExpanded ? content.substring(0, 100) : content;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          child: SelectableText.rich(
            TextSpan(
              children: _buildTextSpans(displayText),
            ),
            style: const TextStyle(
              fontSize: 15,
              height: 1.3,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            if (shouldTruncate) ...[
              GestureDetector(
                onTap: () {
                  print(
                      'See More/Show Less tapped. Current state: $isExpanded'); // Debug
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                  print('New state: $isExpanded'); // Debug
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isExpanded ? "Show Less" : "See More",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
          ],
        ),
      ],
    );
  }

  List<TextSpan> _buildTextSpans(String text) {
    final List<TextSpan> spans = [];
    final RegExp urlRegex = RegExp(
      r'https?://[^\s]+|www\.[^\s]+|[a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9]*\.([a-zA-Z]{2,})[^\s]*',
      caseSensitive: false,
    );

    int lastMatchEnd = 0;

    for (final match in urlRegex.allMatches(text)) {
      // Add text before the URL
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: const TextStyle(color: Colors.black),
        ));
      }

      // Add the clickable URL
      final url = match.group(0)!;
      spans.add(TextSpan(
        text: url,
        style: TextStyle(
          color: Colors.blue[600],
          decoration: TextDecoration.underline,
          decorationColor: Colors.blue[600],
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            _launchUrl(url);
          },
      ));

      lastMatchEnd = match.end;
    }

    // Add remaining text after the last URL
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd),
        style: const TextStyle(color: Colors.black),
      ));
    }

    // If no URLs were found, return the entire text
    if (spans.isEmpty) {
      spans.add(TextSpan(
        text: text,
        style: const TextStyle(color: Colors.black),
      ));
    }

    return spans;
  }

// TODO Use the same _showFullScreen across the entire app
  void _showFullScreenImage(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (context, animation, _) {
          return FadeTransition(
            opacity: animation,
            child: FullScreenImageViewer(imageUrl: imageUrl),
          );
        },
      ),
    );
  }

  void _showFullScreenVideo(BuildContext context, String videoUrl) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (context, animation, _) {
          return FadeTransition(
            opacity: animation,
            child: FullScreenVideoViewer(videoUrl: videoUrl),
          );
        },
      ),
    );
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
                            _formatTimestamp(widget.post.timestamp),
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
                      _buildPostContent(),

                      // Media
                      if (widget.post.imageUrl != null) ...[
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () => _showFullScreenImage(
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
                          onTap: () => _showFullScreenVideo(
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
