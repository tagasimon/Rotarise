import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rotaract/_core/models/club_member_model.dart';

class MembersRepo {
  final CollectionReference _ref;
  MembersRepo(this._ref);

  // create a new member
  Future<void> createMember(ClubMemberModel member) async {
    await _ref.add(member.toMap());
  }

  // update a member
  Future<void> updateMember(ClubMemberModel member) async {
    final ref = await _ref.where('id', isEqualTo: member.id).get();

    if (ref.docs.isNotEmpty) {
      await ref.docs.first.reference.update(member.toMap());
    }
  }

  // delete a member
  Future<void> deleteMember(ClubMemberModel member) async {
    final ref = await _ref.where('id', isEqualTo: member.id).get();

    if (ref.docs.isNotEmpty) {
      await ref.docs.first.reference.delete();
    }
  }

  // get a member by id
  Future<ClubMemberModel?> getMemberById(String id) async {
    final ref = await _ref.where('id', isEqualTo: id).get();

    if (ref.docs.isNotEmpty) {
      return ClubMemberModel.fromMap(ref.docs.first);
    }
    return null;
  }

  // get all members
  Future<List<ClubMemberModel>> getAllMembers() async {
    return await _ref.get().then((snapshot) {
      return snapshot.docs.map((e) => ClubMemberModel.fromMap(e)).toList();
    });
  }

  // get all members by club id
  Future<List<ClubMemberModel>> getAllMembersByClubId(String clubId) async {
    final ref = await _ref.where('clubId', isEqualTo: clubId).get();
    return ref.docs.map((e) => ClubMemberModel.fromMap(e)).toList();
  }
}
