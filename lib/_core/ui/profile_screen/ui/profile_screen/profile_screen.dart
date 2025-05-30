import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/controllers/auth_controller.dart';
import 'package:rotaract/_core/shared_widgets/modern_app_bar_widget.dart';
import 'package:rotaract/_core/ui/profile_screen/ui/profile_screen/widgets/profile_admin_widget.dart';
import 'package:rotaract/_core/ui/profile_screen/ui/profile_screen/widgets/profile_menu_widget.dart';
import 'package:rotaract/_core/ui/profile_screen/ui/profile_screen/widgets/social_media_handles.dart';
import 'package:rotaract/_constants/constants.dart';

class ProfileScreen extends ConsumerWidget {
  static const String route = "/NewProfileScreen";
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authControllerProvider);
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        const ModernAppBarWidget(
          title: "Profile",
          subtitle: "Manage your profile and settings",
        ),
      ],
      body: Container(
        margin: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const ProfileAdminWidget(),
              const SizedBox(height: 10.0),
              const ProfileMenuWidget(),
              const SizedBox(height: 20.0),
              const SocialMediaHandles(),
              const Text(
                '© 2025 Rotaract Club of Kampala North.\nGalilee',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              const Text("v ${Constants.kAppVersion}"),
              TextButton.icon(
                onPressed: state.isLoading
                    ? null
                    : () async {
                        await ref
                            .read(authControllerProvider.notifier)
                            .signOut();
                      },
                label: state.isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Log Out"),
                icon: const Icon(Icons.logout),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
