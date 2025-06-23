import 'package:flutter/material.dart';
import 'package:rotaract/_core/shared_widgets/image_widget.dart';
import 'package:rotaract/admin_tools/ui/club_projects/widgets/impact_card_widget.dart';

class TabImpact extends StatelessWidget {
  const TabImpact({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Project Impact',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          const Row(
            children: [
              Expanded(
                  child: ImpactCardWidget(
                'Students',
                '500+',
                Icons.school,
                Colors.blue,
              )),
              SizedBox(width: 12),
              Expanded(
                  child: ImpactCardWidget(
                'Teachers',
                '25',
                Icons.person,
                Colors.green,
              )),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Expanded(
                  child: ImpactCardWidget(
                'Families',
                '300+',
                Icons.home,
                Colors.orange,
              )),
              SizedBox(width: 12),
              Expanded(
                  child: ImpactCardWidget(
                'Community',
                '2000+',
                Icons.group,
                Colors.purple,
              )),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'Success Stories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildSuccessStory(
            'Maria\'s Story',
            'Thanks to this project, Maria can now attend school regularly and dreams of becoming a teacher.',
            'https://images.unsplash.com/photo-1544717297-fa95b6ee9643?w=80',
          ),
          _buildSuccessStory(
            'Community Growth',
            'The entire village has seen improvements in literacy rates and economic opportunities.',
            'https://images.unsplash.com/photo-1559136555-9303baea8ebd?w=80',
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessStory(String title, String story, String imageUrl) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: ImageWidget(
              imageUrl: imageUrl,
              size: const Size(60, 60),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  story,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                    height: 1.4,
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
