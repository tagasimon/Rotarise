import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rotaract/_core/extensions/extensions.dart';
import 'package:rotaract/_core/notifiers/current_user_notifier.dart';
import 'package:rotaract/_core/notifiers/tab_index_notifier.dart';
import 'package:rotaract/_core/notifiers/upload_image_controller.dart';
import 'package:rotaract/_core/shared_widgets/club_name_by_id_widget.dart';
import 'package:rotaract/_core/shared_widgets/image_widget.dart';
import 'package:rotaract/_core/ui/profile_screen/controllers/club_member_controllers.dart';
import 'package:rotaract/_core/ui/profile_screen/models/club_member_model.dart';
import 'package:rotaract/_core/ui/profile_screen/ui/edit_profile_screen/edit_profile_screen.dart';

class ProfileSection extends ConsumerWidget {
  final ClubMemberModel member;
  final bool isProfileScreen;
  const ProfileSection({
    super.key,
    required this.member,
    required this.isProfileScreen,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state2 = ref.watch(uploadImageControllerProvider);
    ref.listen<AsyncValue>(uploadImageControllerProvider,
        (_, state) => state.showSnackBarOnError(context));
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade50,
            Colors.indigo.shade50,
            Colors.purple.shade50,
          ],
        ),
        border: Border.all(
          color: Colors.blue.shade100,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Centered Stack with proper alignment
          Align(
            alignment: Alignment.center,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Hero(
                  tag: 'member_${member.id}',
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.blue.shade300,
                          Colors.purple.shade400,
                          Colors.pink.shade300,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(4),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: member.imageUrl != null
                            ? ImageWidget(
                                imageUrl: member.imageUrl!,
                                size: const Size(120, 120),
                              )
                            : Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[400],
                                ),
                                child: const Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                // Edit icon positioned at bottom right of the circular avatar
                if (!isProfileScreen)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: state2.isLoading
                          ? null
                          : () async {
                              await _handleProfilePicUpdate(ref);
                            },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF667eea),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: state2.isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.edit,
                                size: 18,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (member.clubId != null) ClubNameByIdWidget(clubId: member.clubId!),
          Text(
            "${member.firstName} ${member.lastName}",
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          if (member.currentClubRole?.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade600,
                    Colors.indigo.shade700,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                member.currentClubRole!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
          if (!isProfileScreen)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () =>
                      context.push(EditProfileEditPage(member: member)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF667eea),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Edit',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _handleProfilePicUpdate(WidgetRef ref) async {
    try {
      // First, pick the image file
      final controller = ref.read(uploadImageControllerProvider.notifier);
      final pickedFile = await controller.pickImageFile();

      if (pickedFile != null) {
        // Then upload the picked file
        final String? downloadUrl =
            await controller.uploadImage(pickedFile, "PROFILE-PICS");

        if (downloadUrl != null) {
          final cUser = ref.read(currentUserNotifierProvider);
          if (cUser == null) return;

          final res = await ref
              .read(clubMemberControllersProvider.notifier)
              .updateMemberPic(cUser.id, downloadUrl);

          if (res) {
            Fluttertoast.showToast(msg: "SUCCESS :)");
            ref.read(tabIndexProvider.notifier).setTabIndex(0);
          }
        }
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to update profile picture: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}
