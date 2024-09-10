import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/core/providers/firebase_providers.dart';
import 'package:rotaract/features/clubs/repos/club_repo.dart';

// club repo provider
final clubRepoProvider = Provider<ClubRepo>((ref) {
  return ClubRepo(ref.watch(firestoreInstanceProvider));
});

// get a club by id
final getClubByIdProvider = FutureProvider.family((ref, String id) async {
  final repo = ref.read(clubRepoProvider);
  return repo.getClubById(id);
});

// get all verified clubs
final getAllVerifiedClubsProvider = FutureProvider((ref) async {
  final repo = ref.read(clubRepoProvider);
  return repo.getAllVerifiedClubs();
});

// get all verified clubs by country
final getAllVerifiedClubsByCountryProvider =
    FutureProvider.family((ref, String country) async {
  final repo = ref.read(clubRepoProvider);
  return repo.getAllVerifiedClubsByCountry(country);
});

// get all verified clubs by city
final getAllVerifiedClubsByCityProvider =
    FutureProvider.family((ref, String city) async {
  final repo = ref.read(clubRepoProvider);
  return repo.getAllVerifiedClubsByCity(city);
});
