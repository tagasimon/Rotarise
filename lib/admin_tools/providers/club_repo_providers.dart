import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/notifiers/selected_club_notifier.dart';
import 'package:rotaract/_core/providers/firebase_providers.dart';
import 'package:rotaract/admin_tools/repos/clubs_repo.dart';

// club repo provider
final clubRepoProvider = Provider<ClubsRepo>((ref) {
  return ClubsRepo(ref.watch(clubsCollectionRefProvider));
});

// get a club by id
final getClubByIdProvider = FutureProvider.autoDispose((ref) async {
  final cClub = ref.read(selectedClubNotifierProvider);

  return ref.read(clubRepoProvider).getClubById(cClub!.id);
});

final getEventClubByIdProvider =
    FutureProvider.autoDispose.family((ref, String clubId) async {
  return ref.read(clubRepoProvider).getClubById(clubId);
});

// get all verified clubs
final getAllVerifiedClubsProvider = FutureProvider((ref) async {
  return ref.read(clubRepoProvider).getAllVerifiedClubs();
});

// get all verified clubs by country
final getAllVerifiedClubsByCountryProvider =
    FutureProvider.family((ref, String country) async {
  return ref.read(clubRepoProvider).getAllVerifiedClubsByCountry(country);
});

// get all verified clubs by city
final getAllVerifiedClubsByCityProvider =
    FutureProvider.family((ref, String city) async {
  return ref.read(clubRepoProvider).getAllVerifiedClubsByCity(city);
});

// get total clubs count
final getTotalClubsCountProvider = FutureProvider((ref) async {
  return ref.read(clubRepoProvider).getTotalClubsCount();
});
