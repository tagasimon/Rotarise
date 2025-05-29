import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rotaract/_core/ui/profile_screen/widgets/list_tile_widget.dart';

class ProfileMenuWidget extends ConsumerWidget {
  const ProfileMenuWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade400, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5.0,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // contact us
            const SizedBox(height: 10),
            ListTileWidget(
              tileTitle: "News?",
              tileIcon: Icons.newspaper,
              onPressed: () {
                Fluttertoast.showToast(msg: "Coming Soon...");
              },
            ),
            const Divider(thickness: 1.0),
            ListTileWidget(
              tileTitle: "FAQs",
              tileIcon: Icons.help_sharp,
              onPressed: () {
                Fluttertoast.showToast(msg: "Coming Soon...");
              },
            ),
            const Divider(
              thickness: 1.0,
              // color: Constants.kSafeBodaGray,
            ),
            ListTileWidget(
              tileTitle: "About the Club",
              tileIcon: Icons.question_mark,
              onPressed: () {
                Fluttertoast.showToast(msg: "Coming Soon...");
              },
            ),
            const Divider(
              thickness: 1.0,
              // color: Constants.kSafeBodaGray,
            ),
            // our story
            ListTileWidget(
              tileTitle: "Our Story",
              tileIcon: Icons.book,
              onPressed: () {
                Fluttertoast.showToast(msg: "Coming Soon...");
              },
            ),
            const Divider(thickness: 1.0),
            // team
            ListTileWidget(
              tileTitle: "Board Members",
              tileIcon: Icons.people,
              onPressed: () {
                Fluttertoast.showToast(msg: "Coming Soon...");
              },
            ),

            const Divider(thickness: 1.0),
            // admin tools
            ListTileWidget(
              tileTitle: "Admin Tools",
              tileIcon: Icons.admin_panel_settings,
              onPressed: () {
                Fluttertoast.showToast(msg: "Coming Soon...");
              },
            ),
          ],
        ),
      ),
    );
  }
}
