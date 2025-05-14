import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rotaract/ui/profile_screen/widgets/profile_admin_widget.dart';
import 'package:rotaract/ui/profile_screen/widgets/profile_menu_widget.dart';

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
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const ProfileAdminWidget(),
                const SizedBox(height: 10.0),
                const ProfileMenuWidget(),
                const SizedBox(height: 20.0),
                // create a row with social media icons to connect with users
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // facebook
                    IconButton(
                      icon: const Icon(
                        FontAwesomeIcons.facebook,
                        size: 30,
                        color: Colors.blue,
                      ),
                      onPressed: () {},
                    ),
                    // instagram
                    IconButton(
                      icon: const Icon(
                        FontAwesomeIcons.instagram,
                        size: 30,
                        color: Colors.pink,
                      ),
                      onPressed: () {},
                    ),
                    // twitter
                    IconButton(
                      icon: const Icon(
                        FontAwesomeIcons.xTwitter,
                        size: 30,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),
                    // tiktok
                    IconButton(
                      icon: const Icon(
                        FontAwesomeIcons.tiktok,
                        size: 30,
                        color: Colors.pinkAccent,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),

                // add copyright text
                const SizedBox(height: 20.0),
                const Text(
                  '© 2025 Rotaract Club of Kampala North.\n',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  'All Rights Reserved.',
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
      ),
    );
  }
}
