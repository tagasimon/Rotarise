import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rotaract/admin_tools/controllers/projects_controllers.dart';
import 'package:rotaract/admin_tools/models/project_model.dart';
import 'package:rotaract/admin_tools/ui/admin_tools/widgets/new_project_sheet.dart';
import 'package:uuid/uuid.dart';

import 'package:rotaract/_core/notifiers/current_user_notifier.dart';
import 'package:rotaract/_core/ui/profile_screen/controllers/club_member_controllers.dart';
import 'package:rotaract/_core/ui/profile_screen/providers/members_repo_provider.dart';
import 'package:rotaract/admin_tools/ui/admin_tools/widgets/action_card_widget.dart';
import 'package:rotaract/admin_tools/ui/admin_tools/widgets/new_event_sheet.dart';
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
              icon: Icons.group_add,
              title: "Add User",
              subtitle: "Add User to Club",
              color: theme.primaryColor,
              // TODO Add addUser to one controller
              onTap: () => _showAddUserDialog(context, ref),
            ),
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
            // ActionCardWidget(
            //   icon: Icons.person_add,
            //   title: "Add Role",
            //   subtitle: "Define new role",
            //   color: const Color(0xFFD4AF37),
            //   onTap: () async {
            //     await showModalBottomSheet(
            //       context: context,
            //       isScrollControlled: true,
            //       backgroundColor: Colors.transparent,
            //       builder: (context) => const NewRoleSheet(),
            //     ).then((result) async {
            //       if (result != null) {
            //         // Handle the returned data
            //         final cUser = ref.watch(currentUserNotifierProvider);
            //         if (cUser?.clubId == null) {
            //           Fluttertoast.showToast(
            //               msg: "Error, You need to belong to a club");
            //           return;
            //         }
            //         final cRole = ClubRole(
            //             id: const Uuid().v4(),
            //             clubId: cUser!.clubId!,
            //             title: result['title'],
            //             description: result['description'],
            //             responsibilities: result['responsibilities'],
            //             createdAt: DateTime.now());
            //         final res = await ref
            //             .read(roleControllerProvider.notifier)
            //             .addRole(cRole);
            //         if (res) {
            //           Fluttertoast.showToast(msg: "SUCCESS :)");
            //         }
            //       }
            //     });
            //   },
            // ),
            // ActionCardWidget(
            //   icon: Icons.group_add,
            //   title: "Add Buddy Group",
            //   subtitle: "Create new Buddy Group",
            //   color: theme.primaryColor,
            //   onTap: () async {
            //     await showModalBottomSheet(
            //       context: context,
            //       isScrollControlled: true,
            //       backgroundColor: Colors.transparent,
            //       builder: (context) => const AddBottomSheet(
            //         title: "Buddy Group",
            //       ),
            //     ).then((result) async {
            //       if (result != null) {
            //         final cUser = ref.watch(currentUserNotifierProvider);
            //         if (cUser == null || cUser.clubId == null) return;
            //         final bg = BuddyGroupModel(
            //           id: const Uuid().v4(),
            //           clubId: cUser.clubId!,
            //           name: result['name'].toString().trim(),
            //           description: result['description'].toString().trim(),
            //           addedBy: cUser.id,
            //         );
            //         final res = await ref
            //             .read(buddyGroupsControllerProvider.notifier)
            //             .addBuddyGroup(bg);
            //         if (res) {
            //           Fluttertoast.showToast(msg: "SUCCESS :)");
            //         }
            //       }
            //     });
            //   },
            // ),
          ],
        ),
      ],
    );
  }

  void _showAddUserDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController emailController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final state = ref.watch(clubMemberControllersProvider);

          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person_add, size: 24),
                      const SizedBox(width: 8),
                      const Text(
                        'Add User to Club',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Enter the user\'s email address to add them to your club:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      hintText: 'user@example.com',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      border: Border.all(color: Colors.amber.shade200),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.amber),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'The user must already have an account. No email suggestions will be shown for privacy.',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: state.isLoading
                        ? null
                        : () async {
                            await _addUserToClub(
                              emailController.text.trim(),
                              setDialogState,
                              context,
                              ref,
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: state.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Add User to Club',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _addUserToClub(
    String email,
    StateSetter setDialogState,
    BuildContext dialogContext,
    WidgetRef ref,
  ) async {
    if (email.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please enter an email address',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    // Basic email validation
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      Fluttertoast.showToast(
        msg: 'Please enter a valid email address',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    final currentUser = ref.read(currentUserNotifierProvider);
    if (currentUser?.clubId == null) {
      Fluttertoast.showToast(
        msg: 'Unable to determine your club',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    try {
      final success = await ref
          .read(clubMemberControllersProvider.notifier)
          .updateMemberClubId(email, currentUser!.clubId!);

      if (success) {
        Fluttertoast.showToast(
          msg: 'User successfully added to club!',
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        // Refresh the members list
        ref.invalidate(clubMembersListByClubIdProvider);

        // Close the dialog
        Navigator.of(dialogContext).pop();
      } else {
        Fluttertoast.showToast(
          msg: 'User not found or could not be added',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error: ${e.toString()}',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}
