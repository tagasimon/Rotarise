import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text("Home"),
            floating: true,
            snap: true,
            actions: [],
          ),
          // center the text
          SliverFillRemaining(
            child: Center(
              child: Text("Other Toastmasters Clubs"),
            ),
          ),
        ],
      ),
    );
  }
}
