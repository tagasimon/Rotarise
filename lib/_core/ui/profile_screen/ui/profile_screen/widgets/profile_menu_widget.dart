import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rotaract/_core/ui/profile_screen/ui/profile_screen/widgets/list_tile_widget.dart';

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
            const SizedBox(height: 10),
            ListTileWidget(
              tileTitle: "POSTS",
              tileIcon: Icons.list_alt_outlined,
              onPressed: () {
                Fluttertoast.showToast(msg: "Coming Soon...");
              },
            ),
            // contact us
            const Divider(thickness: 1.0),
            ListTileWidget(
              tileTitle: "News & Events",
              tileIcon: Icons.event_note_outlined,
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
              tileTitle: "About Club",
              tileIcon: Icons.info_outline,
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
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
