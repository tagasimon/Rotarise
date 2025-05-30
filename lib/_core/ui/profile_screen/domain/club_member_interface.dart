import 'package:rotaract/_core/ui/profile_screen/models/club_member_model.dart';

abstract class ClubMemberInterface {
  Future<void> createMember(ClubMemberModel member);
  Future<void> updateMember(ClubMemberModel member);
  Future<void> deleteMember(ClubMemberModel member);
  Future<ClubMemberModel?> getMemberById(String id);
  Future<List<ClubMemberModel>> getAllMembers();
  Future<List<ClubMemberModel>> getAllMembersByClubId(String clubId);
  Future<int> getTotalMembersCount();
  Future<int> getTotalMembersByClubId(String clubId);
}
