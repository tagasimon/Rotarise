// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/notifiers/current_user_notifier.dart';
import 'package:rotaract/_core/providers/firebase_providers.dart';
import 'package:rotaract/admin_tools/models/buddy_group_model.dart';
import 'package:rotaract/admin_tools/repos/buddy_groups_repo.dart';

final buddyGroupRepoProvider = Provider<BuddyGroupsRepo>((ref) {
  return BuddyGroupsRepo(ref.read(buddyGroupsCollectionRefProvider));
});

// getBuddyGroupsByClubIdProvider
final clubBuddyGroupsByClubIdProvider =
    FutureProvider.autoDispose<List<BuddyGroupModel>>((ref) {
  final cUser = ref.watch(currentUserNotifierProvider);
  if (cUser == null) {
    // return future data with an empty list
    return Future.value([]);
  }
  return ref.read(buddyGroupRepoProvider).getBuddyGroupsByClubId(cUser.clubId!);
});
