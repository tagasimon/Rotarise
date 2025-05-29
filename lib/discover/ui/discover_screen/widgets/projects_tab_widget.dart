import 'package:flutter/material.dart';

class ProjectsTabWidget extends StatelessWidget {
  const ProjectsTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 4, // Mock data
        itemBuilder: (context, index) => _buildProjectCard(index),
      ),
    );
  }

  Widget _buildProjectCard(int index) {
    final mockProjects = [
      {
        'title': 'Clean Water Initiative',
        'description': 'Providing clean water access to rural communities',
        'progress': 0.75,
        'raised': '\$15,000',
        'target': '\$20,000',
        'club': 'Rotaract Mengo',
        'category': 'Water & Sanitation',
      },
      {
        'title': 'Education for All',
        'description': 'Building schools and providing educational materials',
        'progress': 0.60,
        'raised': '\$12,000',
        'target': '\$20,000',
        'club': 'Rotaract Makerere',
        'category': 'Education',
      },
    ];

    final project = mockProjects[index % mockProjects.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  "Title",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Cartegory",
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Description",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${project['raised']} raised",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                "of ${project['target']}",
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: project['progress'] as double,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade400),
            minHeight: 6,
          ),
          const SizedBox(height: 12),
          Text(
            "Club.",
            style: TextStyle(
              color: Colors.purple.shade600,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
