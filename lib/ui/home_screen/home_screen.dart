import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rotaract/extensions/extensions.dart';
import 'package:rotaract/ui/scan_screen/scan_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: const CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text("ROTARACT"),
            centerTitle: true,
            floating: true,
            snap: true,
            actions: null,
          ),
          SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // QrImageView(
                //   data: "Rotaract Club of Kampala North",
                //   version: QrVersions.auto,
                //   size: 320,
                //   gapless: false,
                // ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "post",
        key: const Key("1"),
        onPressed: () {
          context.push(const ScanScreen());
        },
        label: const Text("Clock In"),
        icon: const Icon(FontAwesomeIcons.clock),
      ),
    );
  }
}
