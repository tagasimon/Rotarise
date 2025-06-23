import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/notifiers/discover_tab_index_notifier.dart';
import 'package:rotaract/discover/ui/discover_screen/widgets/stat_card_widget.dart';
import 'package:rotaract/admin_tools/providers/projects_provider.dart';

class ProjectsCountWidget extends ConsumerWidget {
  const ProjectsCountWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countProv = ref.watch(getTotalProjectsCountProvider);
    return GestureDetector(
      onTap: () {
        ref.read(discoverTabIndexProvider.notifier).setTabIndex(2);
      },
      child: countProv.when(data: (count) {
        return StatCardWidget(
            number: "$count",
            label: "Projects",
            icon: Icons.event,
            color: Colors.green.shade400);
      }, error: (e, s) {
        return StatCardWidget(
            number: "_",
            label: "Projects",
            icon: Icons.groups_outlined,
            color: Colors.blue.shade400);
      }, loading: () {
        return StatCardWidget(
            number: "...",
            label: "Projects",
            icon: Icons.event,
            color: Colors.blue.shade400);
      }),
    );
  }
}
