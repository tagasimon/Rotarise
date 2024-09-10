import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventsScreen extends ConsumerWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text("Events"),
            actions: [],
          ),
          // center the text
          SliverFillRemaining(
            child: Center(
              child: Text("Toastmasters Events"),
            ),
          ),
        ],
      ),
    );
  }
}
