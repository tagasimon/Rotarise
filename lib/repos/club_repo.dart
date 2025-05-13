// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rotaract/models/club_model.dart';

class ClubRepo {
  final FirebaseFirestore _firestore;
  ClubRepo(this._firestore);

  // create a new club
  Future<void> createClub(ClubModel club) async {
    await _firestore.collection('CLUBS').add(club.toMap());
  }

  // update a club
  Future<void> updateClub(ClubModel club) async {
    final ref = await _firestore
        .collection('CLUBS')
        .where('id', isEqualTo: club.id)
        .get();

    if (ref.docs.isNotEmpty) {
      await ref.docs.first.reference.update(club.toMap());
    }
  }

  // delete a club
  Future<void> deleteClub(ClubModel club) async {
    final ref = await _firestore
        .collection('CLUBS')
        .where('id', isEqualTo: club.id)
        .get();

    if (ref.docs.isNotEmpty) {
      await ref.docs.first.reference.delete();
    }
  }

  // get a club by id
  Future<ClubModel?> getClubById(String id) async {
    final ref =
        await _firestore.collection('CLUBS').where('id', isEqualTo: id).get();

    if (ref.docs.isNotEmpty) {
      return ClubModel.fromMap(ref.docs.first);
    }
    return null;
  }

  // get all verified clubs
  Future<List<ClubModel>> getAllVerifiedClubs() async {
    final ref = await _firestore
        .collection('CLUBS')
        .where('isVerified', isEqualTo: true)
        .get();
    return ref.docs.map((e) => ClubModel.fromMap(e)).toList();
  }

  // get all verified clubs by country
  Future<List<ClubModel>> getAllVerifiedClubsByCountry(String country) async {
    final ref = await _firestore
        .collection('CLUBS')
        .where('isVerified', isEqualTo: true)
        .where('country', isEqualTo: country)
        .get();
    return ref.docs.map((e) => ClubModel.fromMap(e)).toList();
  }

  // get all verified clubs by city
  Future<List<ClubModel>> getAllVerifiedClubsByCity(String city) async {
    final ref = await _firestore
        .collection('CLUBS')
        .where('isVerified', isEqualTo: true)
        .where('city', isEqualTo: city)
        .get();
    return ref.docs.map((e) => ClubModel.fromMap(e)).toList();
  }
}
