import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/ui/profile_screen/models/club_member_model.dart';
import 'package:rotaract/_core/ui/profile_screen/providers/members_repo_provider.dart';
import 'package:rotaract/_core/ui/profile_screen/repos/club_members_repo.dart';

// club member controllers provider
final clubMemberControllersProvider =
    StateNotifierProvider<ClubMemberControllers, AsyncValue>(
  (ref) => ClubMemberControllers(ref.watch(membersRepoProvider)),
);

class ClubMemberControllers extends StateNotifier<AsyncValue> {
  final ClubMembersRepo _repo;
  ClubMemberControllers(this._repo) : super(const AsyncValue.loading());

  Future<bool> createMember(ClubMemberModel member) async {
    state = const AsyncValue.loading();
    try {
      await _repo.createMember(member);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      return false;
    }
  }

  Future<bool> updateMember(ClubMemberModel member) async {
    state = const AsyncValue.loading();
    try {
      await _repo.updateMember(member);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      return false;
    }
  }

  Future<bool> updateMemberPic(String memberId, String downloadUrl) async {
    state = const AsyncValue.loading();
    try {
      await _repo.updateMemberPic(memberId, downloadUrl);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      return false;
    }
  }

  Future<void> deleteMember(ClubMemberModel member) async {
    state = const AsyncValue.loading();
    try {
      await _repo.deleteMember(member);
      state = const AsyncValue.data(null);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}
