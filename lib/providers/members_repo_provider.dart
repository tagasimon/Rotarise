import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/models/member_model.dart';
import 'package:rotaract/providers/firebase_providers.dart';
import 'package:rotaract/repos/members_repo.dart';

// create all the providers for the members repo
final membersRepoProvider = Provider<MembersRepo>((ref) {
  return MembersRepo(ref.watch(membersCollectionRefProvider));
});

// members list provider
final membersListProvider = FutureProvider<List<MemberModel>>(
  (ref) async {
    final membersRepo = ref.watch(membersRepoProvider);
    return membersRepo.getAllMembers();
  },
);

// get all members by club id
final membersListByClubIdProvider =
    FutureProvider.family<List<MemberModel>, String>((ref, clubId) async {
  final membersRepo = ref.watch(membersRepoProvider);
  return membersRepo.getAllMembersByClubId(clubId);
});
// get a member by id

final memberByIdProvider =
    FutureProvider.family<MemberModel?, String>((ref, id) async {
  final membersRepo = ref.watch(membersRepoProvider);
  return membersRepo.getMemberById(id);
});
