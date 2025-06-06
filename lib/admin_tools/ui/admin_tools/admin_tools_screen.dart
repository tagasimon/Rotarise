import 'package:flutter/material.dart';

class AdminToolsScreen extends StatelessWidget {
  const AdminToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text("Add Club"),
          onTap: () {},
        ),
        ListTile(
          title: const Text("Add Project"),
          onTap: () {},
        ),
        ListTile(
          title: const Text("Add Role"),
          onTap: () {},
        ),
        ListTile(
          title: const Text("Members"),
          onTap: () {},
        )
      ],
    );
  }
}
