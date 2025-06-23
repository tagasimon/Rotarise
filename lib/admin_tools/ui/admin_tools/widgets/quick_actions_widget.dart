// Update this NewEventSheet so that i also select an image along side the other fields for a clubEventModel

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rotaract/admin_tools/controllers/buddy_group_controllers.dart';
import 'package:rotaract/admin_tools/controllers/projects_controllers.dart';
import 'package:rotaract/admin_tools/models/buddy_group_model.dart';
import 'package:rotaract/admin_tools/models/project_model.dart';
import 'package:rotaract/admin_tools/ui/admin_tools/widgets/new_project_sheet.dart';
import 'package:uuid/uuid.dart';

import 'package:rotaract/_core/notifiers/current_user_notifier.dart';
import 'package:rotaract/admin_tools/controllers/roles_controllers.dart';
import 'package:rotaract/admin_tools/models/club_role.dart';
import 'package:rotaract/admin_tools/ui/admin_tools/widgets/action_card_widget.dart';
import 'package:rotaract/admin_tools/ui/admin_tools/widgets/add_bottom_sheet.dart';
import 'package:rotaract/admin_tools/ui/admin_tools/widgets/new_event_sheet.dart';
import 'package:rotaract/admin_tools/ui/admin_tools/widgets/new_role_sheet.dart';
import 'package:rotaract/discover/ui/events_tab_screen/controllers/club_events_controller.dart';
import 'package:rotaract/discover/ui/events_tab_screen/models/club_event_model.dart';

class QuickActionsWidget extends ConsumerWidget {
  const QuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Quick Actions",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2, // Increased from 1.1 to 1.2 for more height
          children: [
            ActionCardWidget(
              icon: Icons.calendar_month_sharp,
              title: "Add Event",
              subtitle: "Create New Event",
              color: const Color(0xFF9C27B0),
              onTap: () async {
                await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const NewEventSheet(),
                ).then((result) async {
                  if (result != null) {
                    final cUser = ref.watch(currentUserNotifierProvider);
                    if (cUser?.clubId == null) {
                      Fluttertoast.showToast(
                          msg: "Error, You need to belong to a club");
                      return;
                    }
                    final cEvent = ClubEventModel(
                        id: const Uuid().v4(),
                        title: result['title'].toString().trim(),
                        startDate: result['startDate'],
                        endDate: result['endDate'],
                        location: result['location'].toString().trim(),
                        clubId: cUser!.clubId!,
                        imageUrl: result['downloadUrl']);
                    final res = await ref
                        .watch(clubEventsControllerProvider.notifier)
                        .addEvent(event: cEvent);
                    if (res) {
                      Fluttertoast.showToast(msg: "Success :)");
                    }
                  }
                });
              },
            ),
            ActionCardWidget(
              icon: Icons.assignment_add,
              title: "Add Project",
              subtitle: "Start new project",
              color: const Color(0xFF2E8B57),
              onTap: () async {
                final ProjectModel? project = await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const NewProjectSheet(),
                );
                if (project == null) return;

                final res = await ref
                    .read(projectsControllerProvider.notifier)
                    .addProject(project);
                if (res) {
                  Fluttertoast.showToast(msg: "SUCCESS :)");
                }
              },
            ),
            ActionCardWidget(
              icon: Icons.person_add,
              title: "Add Role",
              subtitle: "Define new role",
              color: const Color(0xFFD4AF37),
              onTap: () async {
                await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const NewRoleSheet(),
                ).then((result) async {
                  if (result != null) {
                    // Handle the returned data
                    final cUser = ref.watch(currentUserNotifierProvider);
                    if (cUser?.clubId == null) {
                      Fluttertoast.showToast(
                          msg: "Error, You need to belong to a club");
                      return;
                    }
                    final cRole = ClubRole(
                        id: const Uuid().v4(),
                        clubId: cUser!.clubId!,
                        title: result['title'],
                        description: result['description'],
                        responsibilities: result['responsibilities'],
                        createdAt: DateTime.now());
                    final res = await ref
                        .read(roleControllerProvider.notifier)
                        .addRole(cRole);
                    if (res) {
                      Fluttertoast.showToast(msg: "SUCCESS :)");
                    }
                  }
                });
              },
            ),
            ActionCardWidget(
              icon: Icons.group_add,
              title: "Add Buddy Group",
              subtitle: "Create new Buddy Group",
              color: theme.primaryColor,
              onTap: () async {
                await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const AddBottomSheet(
                    title: "Buddy Group",
                  ),
                ).then((result) async {
                  if (result != null) {
                    final cUser = ref.watch(currentUserNotifierProvider);
                    if (cUser == null || cUser.clubId == null) return;
                    final bg = BuddyGroupModel(
                      id: const Uuid().v4(),
                      clubId: cUser.clubId!,
                      name: result['name'].toString().trim(),
                      description: result['description'].toString().trim(),
                      addedBy: cUser.id,
                    );

                    final res = await ref
                        .read(buddyGroupsControllerProvider.notifier)
                        .addBuddyGroup(bg);
                    if (res) {
                      Fluttertoast.showToast(msg: "SUCCESS :)");
                    }
                  }
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
