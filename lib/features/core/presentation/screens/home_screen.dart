import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Row(
              children: [
                const Text("Rotaract"),
                PopupMenuButton(
                  icon: const Icon(Icons.arrow_drop_down_sharp),
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        child: Row(
                          children: [
                            Icon(Icons.home),
                            Text("Home"),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        child: Row(
                          children: [
                            Icon(Icons.arrow_outward_sharp),
                            Text("Popular"),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        child: Row(
                          children: [
                            Icon(Icons.newspaper_sharp),
                            Text("Latest"),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
              ],
            ),
            floating: true,
            snap: true,
            actions: null,
          ),
          // center the text
          const SliverFillRemaining(
            child: Center(
              child: Text("Home.."),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "post",
        key: const Key("1"),
        onPressed: () {},
        label: const Text("Clock In"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
