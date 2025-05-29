import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/shared_widgets/modern_app_bar_widget.dart';
import 'package:rotaract/_core/ui/profile_screen/widgets/profile_admin_widget.dart';
import 'package:rotaract/_core/ui/profile_screen/widgets/profile_menu_widget.dart';
import 'package:rotaract/_core/ui/profile_screen/widgets/social_media_handles.dart';

class ProfileScreen extends ConsumerWidget {
  static const String route = "/NewProfileScreen";
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        child: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ProfileAdminWidget(),
              SizedBox(height: 10.0),
              ProfileMenuWidget(),
              SizedBox(height: 20.0),
              SocialMediaHandles(),
              Text(
                '© 2025 Rotaract Club of Kampala North.\n',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              // Text(AppStrings.kAppVersion),
              // LogOutButtonWidget(),
            ],
          ),
        ),
      ),
    ));
  }
}
