import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/core/providers/firebase_providers.dart';
import 'package:rotaract/features/auth/models/app_user.dart';
import 'package:rotaract/features/auth/models/user_model.dart';
import 'package:rotaract/features/auth/repos/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(
    ref.watch(firebaseAuthProvider),
    ref.watch(firestoreInstanceProvider),
  ),
);

final authStateChangesProvider = StreamProvider<AppUser?>((ref) {
  return ref.watch(authRepositoryProvider).onAuthStateChanges();
});

final watchCurrentUserProvider = StreamProvider.autoDispose<UserModel>((ref) {
  return ref.watch(authRepositoryProvider).watchCurrentUserInfo();
});

// watchUserInfo provides the user information
final watchUserInfoProvider =
    StreamProvider.autoDispose.family<UserModel, String>((ref, id) {
  return ref.watch(authRepositoryProvider).watchUserInfo(id);
});
