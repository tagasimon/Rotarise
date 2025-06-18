import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/notifiers/current_user_notifier.dart';
import 'package:rotaract/_core/notifiers/selected_club_notifier.dart';
import 'package:rotaract/_core/ui/profile_screen/models/club_member_model.dart';
import 'package:rotaract/_core/providers/firebase_providers.dart';
import 'package:rotaract/_core/ui/profile_screen/repos/club_members_repo.dart';

// create all the providers for the members repo
final membersRepoProvider = Provider<ClubMembersRepo>((ref) {
  return ClubMembersRepo(ref.watch(membersCollectionRefProvider));
});

// members list provider
final membersListProvider = FutureProvider<List<ClubMemberModel>>(
  (ref) async {
    final membersRepo = ref.watch(membersRepoProvider);
    return membersRepo.getAllMembers();
  },
);

// get all members by club id
final membersListByClubIdProvider =
    FutureProvider.autoDispose<List<ClubMemberModel>>((ref) async {
  final cClub = ref.watch(selectedClubNotifierProvider);
  final membersRepo = ref.watch(membersRepoProvider);
  if (cClub == null) return [];
  return membersRepo.getAllMembersByClubId(cClub.id);
});

// get all members by club id
final clubMembersListByClubIdProvider =
    FutureProvider.autoDispose<List<ClubMemberModel>>((ref) async {
  final cUser = ref.watch(currentUserNotifierProvider);
  if (cUser == null || cUser.clubId == null) return [];
  return ref.watch(membersRepoProvider).getAllMembersByClubId(cUser.clubId!);
  // 0b65b229-2114-41e5-be04-d4d688ee08b5
});

// get a member by id
final memberByIdProvider =
    FutureProvider.family<ClubMemberModel?, String>((ref, id) async {
  final membersRepo = ref.watch(membersRepoProvider);
  return membersRepo.getMemberById(id);
});

// total members count
final totalMembersCountProvider = FutureProvider<int>((ref) async {
  final membersRepo = ref.watch(membersRepoProvider);
  return membersRepo.getTotalMembersCount();
});
// total members by club id
final totalMembersByClubIdProvider = FutureProvider<int>((ref) async {
  final cClub = ref.read(selectedClubNotifierProvider);
  final membersRepo = ref.watch(membersRepoProvider);
  if (cClub == null) {
    return 0; // or handle the case where no club is selected
  }
  return membersRepo.getTotalMembersByClubId(cClub.id);
});
