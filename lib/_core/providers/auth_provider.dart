import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/models/club_member_model.dart';
import 'package:rotaract/_core/providers/firebase_providers.dart';
import 'package:rotaract/_core/models/app_user.dart';
import 'package:rotaract/_core/repos/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(
    ref.watch(firebaseAuthProvider),
    ref.watch(membersCollectionRefProvider),
  ),
);

final authStateChangesProvider = StreamProvider<AppUser?>((ref) {
  return ref.watch(authRepositoryProvider).onAuthStateChanges();
});

final watchCurrentUserProvider =
    StreamProvider.autoDispose<ClubMemberModel>((ref) {
  return ref.watch(authRepositoryProvider).watchCurrentUserInfo();
});

// watchUserInfo provides the user information
final watchUserInfoProvider =
    StreamProvider.autoDispose.family<ClubMemberModel, String>((ref, id) {
  return ref.watch(authRepositoryProvider).watchUserInfo(id);
});
