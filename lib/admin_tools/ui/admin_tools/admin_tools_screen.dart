import 'package:flutter/material.dart';
import 'package:rotaract/_core/extensions/extensions.dart';
import 'package:rotaract/_core/shared_widgets/modern_app_bar_widget.dart';
import 'package:rotaract/admin_tools/ui/admin_tools/widgets/management_actions_widget.dart';
import 'package:rotaract/admin_tools/ui/admin_tools/widgets/quick_actions_widget.dart';
import 'package:rotaract/discover/ui/club_home_screen/widgets/share_button_widget.dart';

class AdminToolsScreen extends StatelessWidget {
  const AdminToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            ModernAppBarWidget(
              leading: ShareButtonWidget(
                icon: Icons.arrow_back_ios_new_rounded,
                onPressed: () => context.pop(false),
              ),
              title: "Admin Tools",
              subtitle: "Manage clubs, projects, and members",
            ),
          ];
        },
        body: const SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              QuickActionsWidget(),
              SizedBox(height: 16),
              ManagementActionsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
