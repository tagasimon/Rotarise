import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_constants/constants.dart';
import 'package:rotaract/_core/providers/app_theme_provider.dart';
import 'package:rotaract/_core/ui/main_tabs_screen/widgets/auth_widget.dart';

class AppWidget extends ConsumerWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: Constants.kAppTitle,
      debugShowCheckedModeBanner: false,
      theme: ref.watch(appThemeProvider),
      home: const AuthWidget(),
    );
  }
}
