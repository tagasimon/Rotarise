import 'package:rotaract/models/club_model.dart';

abstract class ClubInterface {
  Future<void> createClub(ClubModel club);
  Future<void> updateClub(ClubModel club);
  Future<void> deleteClub(ClubModel club);
  Future<ClubModel?> getClubById(String id);
  Future<List<ClubModel>> getAllVerifiedClubs();
  Future<List<ClubModel>> getAllVerifiedClubsByCountry(String country);
  Future<List<ClubModel>> getAllVerifiedClubsByCity(String city);
}
