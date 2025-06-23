import 'package:flutter/material.dart';
import 'package:rotaract/admin_tools/models/project_model.dart';
import 'package:rotaract/admin_tools/ui/club_projects/widgets/gallery_tab.dart';
import 'package:rotaract/admin_tools/ui/club_projects/widgets/tab_impact.dart';
import 'package:rotaract/admin_tools/ui/club_projects/widgets/updates_tab_widget.dart';

class TabSection extends StatelessWidget {
  final TabController tabController;
  final Color projectColor;
  final ProjectModel project;
  const TabSection({
    super.key,
    required this.tabController,
    required this.projectColor,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: TabBar(
            controller: tabController,
            indicator: BoxDecoration(
              color: projectColor,
              borderRadius: BorderRadius.circular(12),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey.shade600,
            labelStyle:
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            tabs: const [
              Tab(text: 'About'),
              Tab(text: 'Updates'),
              Tab(text: 'Gallery'),
              Tab(text: 'Impact'),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 600,
          child: TabBarView(
            controller: tabController,
            children: [
              TabSection(
                project: project,
                projectColor: projectColor,
                tabController: tabController,
              ),
              UpdatesTabWidget(project: project),
              const GalleryTab(),
              const TabImpact(),
            ],
          ),
        ),
      ],
    );
  }
}
