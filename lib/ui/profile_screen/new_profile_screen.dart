import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/ui/profile_screen/widgets/profile_admin_widget.dart';
import 'package:rotaract/ui/profile_screen/widgets/profile_menu_widget.dart';
import 'package:rotaract/ui/profile_screen/widgets/social_media_handles.dart';

class NewProfileScreen extends ConsumerWidget {
  static const String route = "/NewProfileScreen";
  const NewProfileScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ACCOUNT',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
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
    );
  }
}
