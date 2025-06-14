import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/extensions/extensions.dart';
import 'package:rotaract/admin_tools/ui/admin_tools/widgets/management_card_widget.dart';
import 'package:rotaract/admin_tools/ui/events_screen/club_events_screen.dart';

class ManagementActionsWidget extends ConsumerWidget {
  const ManagementActionsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Management",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        // const SizedBox(height: 12),
        // ManagementCardWidget(
        //   icon: Icons.bar_chart,
        //   title: "Reports",
        //   subtitle: "View Reports",
        //   onTap: () {},
        // ),
        const SizedBox(height: 12),
        ManagementCardWidget(
          icon: Icons.calendar_month,
          title: "Events",
          subtitle: "Manage Events",
          onTap: () => context.push(const EventsByClubScreen()),
        ),
        const SizedBox(height: 12),
        ManagementCardWidget(
          icon: Icons.assignment_sharp,
          title: "Projects",
          subtitle: "Manage Projects",
          onTap: () {},
        ),
        const SizedBox(height: 12),
        ManagementCardWidget(
          icon: Icons.groups_3_outlined,
          title: "Members",
          subtitle: "Manage members",
          onTap: () {},
        ),
        const SizedBox(height: 16),
        ManagementCardWidget(
          icon: Icons.groups_2_outlined,
          title: "Buddy Groups",
          subtitle: "View and Manage Buddy Groups",
          onTap: () {},
        ),
        const SizedBox(height: 12),
        ManagementCardWidget(
          icon: Icons.account_tree_rounded,
          title: "Roles",
          subtitle: "View and Manage Club Roles",
          onTap: () {},
        ),
      ],
    );
  }
}
