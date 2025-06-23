import 'package:flutter/material.dart';
import 'package:rotaract/admin_tools/models/project_model.dart';
import 'package:rotaract/admin_tools/ui/club_projects/widgets/update_card_widget.dart';

class UpdatesTabWidget extends StatelessWidget {
  final ProjectModel project;
  const UpdatesTabWidget({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final updates = [
      {
        'date': '2024-05-15',
        'title': 'Foundation Complete!',
        'description':
            'We have successfully completed the foundation work for the new school building.',
        'image':
            'https://images.unsplash.com/photo-1541888946425-d81bb19240f5?w=400',
        'progress': 30,
      },
      {
        'date': '2024-04-20',
        'title': 'Construction Begins',
        'description':
            'Ground breaking ceremony completed with community leaders and donors.',
        'image':
            'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=400',
        'progress': 15,
      },
      {
        'date': '2024-03-10',
        'title': 'Project Launch',
        'description':
            'Official project launch with fundraising campaign kickoff.',
        'image':
            'https://images.unsplash.com/photo-1559136555-9303baea8ebd?w=400',
        'progress': 5,
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: updates
            .map((update) => UpdateCardWidget(project: project))
            .toList(),
      ),
    );
  }
}
