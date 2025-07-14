import 'package:flutter/material.dart';
import 'package:rotaract/news_feed/widgets/mentionable_text.dart';

class PostContentWidget extends StatefulWidget {
  final String content;
  final bool isExpanded;
  final Function() onSeeMoreTapped;
  const PostContentWidget({
    super.key,
    required this.content,
    required this.isExpanded,
    required this.onSeeMoreTapped,
  });

  @override
  State<PostContentWidget> createState() => _PostContentWidgetState();
}

class _PostContentWidgetState extends State<PostContentWidget> {
  @override
  Widget build(BuildContext context) {
    // final content = widget.post.content ?? "";

    if (widget.content.isEmpty) {
      return const SizedBox.shrink();
    }

    final shouldTruncate = widget.content.length > 100;
    final displayText = shouldTruncate && !widget.isExpanded
        ? widget.content.substring(0, 100)
        : widget.content;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          child: MentionableText(
            text: displayText,
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
                onTap: widget.onSeeMoreTapped,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.isExpanded ? "Show Less" : "See More",
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
}
