import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/models/app_user.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue>(
  (ref) => AuthController(),
);

class AuthController extends StateNotifier<AsyncValue<AppUser>> {
  AuthController() : super(AsyncValue.data(AppUser(null)));

  Future<void> signOut() async {
    try {
      state = const AsyncValue.loading();
      await FirebaseAuth.instance.signOut();
      state = AsyncValue.data(AppUser(null));
      return;
    } catch (e, stk) {
      state = AsyncValue.error(e, stk);
      return;
    }
  }
}
