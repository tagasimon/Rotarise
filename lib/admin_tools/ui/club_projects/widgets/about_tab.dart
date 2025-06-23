import 'package:flutter/material.dart';
import 'package:rotaract/admin_tools/models/project_model.dart';
import 'package:rotaract/admin_tools/ui/club_projects/widgets/goal_item.dart';

class AboutTab extends StatelessWidget {
  final ProjectModel project;
  const AboutTab({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Project Description',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            project.description,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 16,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Project Goals',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          const GoalItem('Provide quality education to 500+ children'),
          const GoalItem('Build modern classroom facilities'),
          const GoalItem('Train local teachers and staff'),
          const GoalItem('Establish sustainable funding model'),
          const SizedBox(height: 32),
          const Text(
            'Location',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, color: Colors.red.shade400),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Kakindu Village, Mukono District, Uganda',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
