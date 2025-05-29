import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/ui/main_tabs_screen/main_tabs_screen.dart';
import 'package:rotaract/_core/ui/sign_in_screen/custom_sign_in_screen.dart';
import 'package:rotaract/_core/providers/auth_provider.dart';

class AuthWidget extends ConsumerWidget {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateChangesProv = ref.watch(authStateChangesProvider);
    return authStateChangesProv.when(
      data: (user) {
        if (user?.uid == null) {
          return const CustomSignInScreen();
        }
        return const MainTabsScreen();
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, s) => Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }
}
