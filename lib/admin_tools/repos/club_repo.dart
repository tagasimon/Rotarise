// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rotaract/admin_tools/domain/club_interface.dart';
import 'package:rotaract/admin_tools/models/club_model.dart';

class ClubRepo implements ClubInterface {
  final CollectionReference _ref;
  ClubRepo(this._ref);

  // Simple cache
  List<ClubModel>? _cachedClubs;
  DateTime? _lastFetch;

  // create a new club
  @override
  Future<void> createClub(ClubModel club) async {
    await _ref.add(club.toMap());
  }

  // update a club
  @override
  Future<void> updateClub(ClubModel club) async {
    final ref = await _ref.where('id', isEqualTo: club.id).get();

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
      return ClubModel.fromFirestore(ref.docs.first);
    }
    return null;
  }

  @override
  Future<List<ClubModel>> getAllVerifiedClubs() async {
    try {
      // Return cache if less than 2 minutes old
      if (_cachedClubs != null &&
          _lastFetch != null &&
          DateTime.now().difference(_lastFetch!).inMinutes < 2) {
        return _cachedClubs!;
      }

      // Fetch from Firestore with limit to prevent memory issues
      final snapshot = await _ref
          .where('isVerified', isEqualTo: true)
          // .limit(100) // Limit to first 100 clubs
          .get();

      final clubs =
          snapshot.docs.map((doc) => ClubModel.fromFirestore(doc)).toList();

      // Update cache
      _cachedClubs = clubs;
      _lastFetch = DateTime.now();

      return clubs;
    } catch (e) {
      // Return cached data if available, otherwise throw error
      if (_cachedClubs != null) {
        return _cachedClubs!;
      }
      throw Exception('Failed to load clubs: $e');
    }
  }

  // get all verified clubs by country
  @override
  Future<List<ClubModel>> getAllVerifiedClubsByCountry(String country) async {
    final ref = await _ref
        .where('isVerified', isEqualTo: true)
        .where('country', isEqualTo: country)
        .get();
    return ref.docs.map((e) => ClubModel.fromFirestore(e)).toList();
  }

  // get all verified clubs by city
  @override
  Future<List<ClubModel>> getAllVerifiedClubsByCity(String city) async {
    final ref = await _ref
        .where('isVerified', isEqualTo: true)
        .where('city', isEqualTo: city)
        .get();
    return ref.docs.map((e) => ClubModel.fromFirestore(e)).toList();
  }

  @override
  Future<int> getTotalClubsCount() {
    return _ref.count().get().then((value) => value.count ?? 0);
  }
}
