import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/admin_tools/models/buddy_group_model.dart';
import 'package:rotaract/admin_tools/providers/club_buddy_groups_providers.dart';
import 'package:rotaract/admin_tools/repos/buddy_groups_repo.dart';

// role controller provider
final buddyGroupsControllerProvider =
    StateNotifierProvider<BuddyGroupControllers, AsyncValue>(
  (ref) => BuddyGroupControllers(ref.watch(buddyGroupRepoProvider)),
);

class BuddyGroupControllers extends StateNotifier<AsyncValue> {
  final BuddyGroupsRepo _repo;
  BuddyGroupControllers(this._repo) : super(const AsyncData([]));

  Future<bool> addBuddyGroup(BuddyGroupModel bg) async {
    state = const AsyncLoading();
    try {
      await _repo.createBuddyGroup(bg);
      state = const AsyncData(null);
      return true;
    } catch (e, s) {
      state = AsyncError(e, s);
      return false;
    }
  }
}
