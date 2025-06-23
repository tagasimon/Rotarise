import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/notifiers/current_user_notifier.dart';
import 'package:rotaract/_core/notifiers/selected_club_notifier.dart';
import 'package:rotaract/_core/providers/firebase_providers.dart';
import 'package:rotaract/discover/ui/events_tab_screen/models/club_event_model.dart';
import 'package:rotaract/discover/ui/events_tab_screen/repos/club_events_repo.dart';

final clubEventsRepoProvider = Provider<ClubEventsRepo>((ref) {
  return ClubEventsRepo(ref.watch(eventsCollectionRefProvider));
});

// getAllEvents provider
final allEventsProvider = FutureProvider((ref) async {
  return ref.watch(clubEventsRepoProvider).getAllEvents();
});

// getEventById
final clubEventByIdProvider =
    FutureProvider.family.autoDispose((ref, String eventId) async {
  return ref.watch(clubEventsRepoProvider).getEventById(eventId);
});

// getEventsByClubId
final eventsByClubIdProvider =
    FutureProvider<List<ClubEventModel>>((ref) async {
  final cClub = ref.watch(selectedClubNotifierProvider);
  final repo = ref.watch(clubEventsRepoProvider);
  if (cClub == null) {
    return []; // or handle the case where no club is selected
  }
  return repo.getEventsByClubId(cClub.id);
});

// getEventsByClubId
final adminEventsByClubIdProvider =
    FutureProvider.autoDispose<List<ClubEventModel>>((ref) async {
  final cUser = ref.watch(currentUserNotifierProvider);
  final repo = ref.watch(clubEventsRepoProvider);
  if (cUser == null || cUser.clubId == null) {
    return []; // or handle the case where no club is selected
  }
  return repo.getEventsByClubId(cUser.clubId!);
});

// get total events count
final getTotalEventsCountProvider = FutureProvider((ref) async {
  return ref.read(clubEventsRepoProvider).getTotalEventsCount();
});

// get total events by club id
final getTotalEventsByClubIdProvider = FutureProvider((ref) async {
  final cClub = ref.watch(selectedClubNotifierProvider);
  final repo = ref.watch(clubEventsRepoProvider);
  if (cClub == null) {
    return 0; // or handle the case where no club is selected
  }
  return repo.getTotalEventsByClubId(cClub.id);
});
