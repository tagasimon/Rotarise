// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rotaract/admin_tools/domain/club_interface.dart';
import 'package:rotaract/admin_tools/models/club_model.dart';

class ClubRepo implements ClubInterface {
  final CollectionReference _ref;
  ClubRepo(this._ref);

  // create a new club
  @override
  Future<void> createClub(ClubModel club) async {
    await _ref.add(club.toMap());
  }

  // update a club
  @override
  Future<void> updateClub(ClubModel club) async {
    final ref = await _ref
        .where('id', isEqualTo: club.id)
        .where('id', isEqualTo: club.id)
        .get();

    if (ref.docs.isNotEmpty) {
      await ref.docs.first.reference.update(club.toMap());
    }
  }

  // delete a club
  @override
  Future<void> deleteClub(ClubModel club) async {
    final ref = await _ref.where('id', isEqualTo: club.id).get();

    if (ref.docs.isNotEmpty) {
      await ref.docs.first.reference.delete();
    }
  }

  // get a club by id
  @override
  Future<ClubModel?> getClubById(String id) async {
    final ref = await _ref.where('id', isEqualTo: id).get();

    if (ref.docs.isNotEmpty) {
      return ClubModel.fromMap(ref.docs.first);
    }
    return null;
  }

  // get all verified clubs
  @override
  Future<List<ClubModel>> getAllVerifiedClubs() async {
    final ref = await _ref.where('isVerified', isEqualTo: true).get();
    return ref.docs.map((e) => ClubModel.fromMap(e)).toList();
  }

  // get all verified clubs by country
  @override
  Future<List<ClubModel>> getAllVerifiedClubsByCountry(String country) async {
    final ref = await _ref
        .where('isVerified', isEqualTo: true)
        .where('country', isEqualTo: country)
        .get();
    return ref.docs.map((e) => ClubModel.fromMap(e)).toList();
  }

  // get all verified clubs by city
  @override
  Future<List<ClubModel>> getAllVerifiedClubsByCity(String city) async {
    final ref = await _ref
        .where('isVerified', isEqualTo: true)
        .where('city', isEqualTo: city)
        .get();
    return ref.docs.map((e) => ClubModel.fromMap(e)).toList();
  }
}
