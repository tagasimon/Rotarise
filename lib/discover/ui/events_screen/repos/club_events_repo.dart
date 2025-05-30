// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:rotaract/discover/ui/events_screen/domain/club_events_interface.dart';
import 'package:rotaract/discover/ui/events_screen/models/club_event_model.dart';

class ClubEventsRepo implements ClubEventsInterface {
  final CollectionReference ref;
  ClubEventsRepo(this.ref);

  @override
  Future<void> addEvent({required ClubEventModel event}) async {
    await ref.add(event.toMap());
  }

  @override
  Future<void> updateEvent({required ClubEventModel event}) async {
    await ref.doc(event.id).update(event.toMap());
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    await ref.doc(eventId).delete();
  }

  @override
  Future<List<ClubEventModel>> getAllEvents() async {
    final snapshot = await ref.orderBy('startDate', descending: true).get();
    return snapshot.docs.map((doc) => ClubEventModel.fromMap(doc)).toList();
  }

  @override
  Future<ClubEventModel?> getEventById(String eventId) async {
    final doc = await ref.doc(eventId).get();
    if (doc.exists) {
      return ClubEventModel.fromMap(doc);
    }
    return null;
  }

  @override
  Future<List<ClubEventModel>> getEventsByClubId(String clubId) async {
    final snapshot = await ref
        .where('clubId', isEqualTo: clubId)
        .orderBy('startDate', descending: true)
        .get();
    return snapshot.docs.map((doc) => ClubEventModel.fromMap(doc)).toList();
  }

  @override
  Future<int> getTotalEventsCount() {
    return ref.count().get().then((value) => value.count ?? 0);
  }

  @override
  Future<int> getTotalEventsByClubId(String clubId) {
    return ref
        .where('clubId', isEqualTo: clubId)
        .count()
        .get()
        .then((value) => value.count ?? 0);
  }
}
