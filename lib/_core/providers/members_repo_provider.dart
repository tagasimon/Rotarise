import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/models/club_member_model.dart';
import 'package:rotaract/_core/providers/firebase_providers.dart';
import 'package:rotaract/_core/repos/members_repo.dart';

// create all the providers for the members repo
final membersRepoProvider = Provider<MembersRepo>((ref) {
  return MembersRepo(ref.watch(membersCollectionRefProvider));
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
    FutureProvider.family<List<ClubMemberModel>, String>((ref, clubId) async {
  final membersRepo = ref.watch(membersRepoProvider);
  return membersRepo.getAllMembersByClubId(clubId);
});
// get a member by id

final memberByIdProvider =
    FutureProvider.family<ClubMemberModel?, String>((ref, id) async {
  final membersRepo = ref.watch(membersRepoProvider);
  return membersRepo.getMemberById(id);
});
