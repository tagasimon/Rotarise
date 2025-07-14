import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/news_feed/widgets/mention_text_field.dart';
import 'package:rotaract/news_feed/widgets/mentionable_text.dart';
import 'package:rotaract/news_feed/widgets/tagged_clubs_widget.dart';

/// Example usage of the Club Tagging System
class ClubTaggingExample extends ConsumerStatefulWidget {
  const ClubTaggingExample({super.key});

  @override
  ConsumerState<ClubTaggingExample> createState() => _ClubTaggingExampleState();
}

class _ClubTaggingExampleState extends ConsumerState<ClubTaggingExample> {
  final TextEditingController _controller = TextEditingController();
  List<String> _taggedClubIds = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Club Tagging System Demo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input section with mention support
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Create a Post with Club Mentions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    MentionTextField(
                      controller: _controller,
                      hintText: "Try typing @Rotaract to mention clubs...",
                      maxLines: 4,
                      onMentionsChanged: (taggedIds) {
                        setState(() {
                          _taggedClubIds = taggedIds;
                        });
                      },
                    ),
                    if (_taggedClubIds.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      const Text(
                        'Tagged Clubs:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TaggedClubsWidget(taggedClubIds: _taggedClubIds),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Preview section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Preview (with clickable mentions)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: _controller.text.isNotEmpty
                          ? MentionableText(
                              text: _controller.text,
                              style: const TextStyle(fontSize: 16),
                            )
                          : const Text(
                              'Your post preview will appear here...',
                              style: TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Instructions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'How to Use',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '1. Type @ followed by a club name (e.g., @Rotaract)',
                      style: TextStyle(fontSize: 14),
                    ),
                    const Text(
                      '2. Select from the dropdown suggestions',
                      style: TextStyle(fontSize: 14),
                    ),
                    const Text(
                      '3. Tagged clubs appear as blue chips below',
                      style: TextStyle(fontSize: 14),
                    ),
                    const Text(
                      '4. Mentions in preview are clickable and navigate to club profiles',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
