import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/admin_tools/providers/projects_provider.dart';
import 'package:rotaract/discover/ui/projects_tab_screen/widgets/project_card.dart';

class ProjectsTabScreen extends ConsumerWidget {
  const ProjectsTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectProv = ref.watch(allProjectsProvider);
    return projectProv.when(
      data: (projects) {
        if (projects.isEmpty) {
          return const Center(child: Text("No Projects"));
        }
        return Container(
          margin: const EdgeInsets.only(top: 20),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: projects.length,
            itemBuilder: (context, index) =>
                ProjectCard(project: projects[index]),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
