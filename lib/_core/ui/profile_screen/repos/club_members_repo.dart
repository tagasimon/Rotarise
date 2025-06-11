import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rotaract/_core/ui/profile_screen/domain/club_member_interface.dart';
import 'package:rotaract/_core/ui/profile_screen/models/club_member_model.dart';

class ClubMembersRepo extends ClubMemberInterface {
  final CollectionReference _ref;
  ClubMembersRepo(this._ref);

  // create a new member
  @override
  Future<void> createMember(ClubMemberModel member) async {
    await _ref.add(member.toMap());
  }

  // update a member
  @override
  Future<void> updateMember(ClubMemberModel member) async {
    final ref = await _ref.where('id', isEqualTo: member.id).get();

    if (ref.docs.isNotEmpty) {
      await ref.docs.first.reference.update(member.toMap());
    }
  }

  // delete a member
  @override
  Future<void> deleteMember(ClubMemberModel member) async {
    final ref = await _ref.where('id', isEqualTo: member.id).get();

    if (ref.docs.isNotEmpty) {
      await ref.docs.first.reference.delete();
    }
  }

  // get a member by id
  @override
  Future<ClubMemberModel?> getMemberById(String id) async {
    final ref = await _ref.where('id', isEqualTo: id).get();

    if (ref.docs.isNotEmpty) {
      return ClubMemberModel.fromFirestore(ref.docs.first);
    }
    return null;
  }

  // get all members
  @override
  Future<List<ClubMemberModel>> getAllMembers() async {
    return await _ref.get().then((snapshot) {
      return snapshot.docs
          .map((e) => ClubMemberModel.fromFirestore(e))
          .toList();
    });
  }

  // get all members by club id
  @override
  Future<List<ClubMemberModel>> getAllMembersByClubId(String clubId) async {
    final ref = await _ref.where('clubId', isEqualTo: clubId).get();
    return ref.docs.map((e) => ClubMemberModel.fromFirestore(e)).toList();
  }

  @override
  Future<int> getTotalMembersByClubId(String clubId) {
    return _ref
        .where('clubId', isEqualTo: clubId)
        .count()
        .get()
        .then((value) => value.count ?? 0);
  }

  @override
  Future<int> getTotalMembersCount() {
    return _ref.count().get().then((value) => value.count ?? 0);
  }

  @override
  Future<void> updateMemberPic(String memberId, String downloadUrl) async {
    final ref = await _ref.where('id', isEqualTo: memberId).get();
    if (ref.docs.isNotEmpty) {
      await ref.docs.first.reference.update({
        'imageUrl': downloadUrl,
      });
    }
  }
}
