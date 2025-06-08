import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rotaract/_core/extensions/extensions.dart';
import 'package:rotaract/_core/notifiers/current_user_notifier.dart';
import 'package:rotaract/_core/ui/profile_screen/ui/edit_profile_screen/edit_profile_screen.dart';
import 'package:share_plus/share_plus.dart';

class ProfileHeaderWidget extends ConsumerWidget {
  const ProfileHeaderWidget({super.key});

  Future<void> _pickImage(WidgetRef ref) async {
    final ImagePicker picker = ImagePicker();

    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        // TODO: Implement image upload logic here
        // You can access the image file path with: image.path
        // Update user profile image through your notifier

        // Example of how you might update the user's profile image:
        // await ref.read(currentUserNotifierProvider.notifier).updateProfileImage(image.path);

        // Show success message
        Fluttertoast.showToast(msg: "SUCCESS :)");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to pick image");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cMember = ref.watch(currentUserNotifierProvider);

    return Container(
      padding: const EdgeInsets.fromLTRB(30, 30, 30, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Profile Avatar with gradient border and edit icon
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF4A90E2), Colors.teal],
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: cMember?.imageUrl != null
                        ? NetworkImage(cMember!.imageUrl!)
                        : null,
                    child: cMember?.imageUrl == null
                        ? Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.grey[600],
                          )
                        : null,
                  ),
                ),
              ),

              // Edit icon positioned at bottom right
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _pickImage(ref),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF667eea),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Name and Email
          Text(
            '${cMember?.firstName} ${cMember?.lastName}',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              cMember?.email ?? "",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Edit Profile Button
          ElevatedButton(
            onPressed: () =>
                context.push(EditProfileEditPage(member: cMember!)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF667eea),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Edit Profile',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
