// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ClubEventModel {
  final String id;
  final String title;
  final Object startDate;
  final Object endDate;
  final String location;
  final String clubId;
  final String? imageUrl;
  final bool isOnline;
  final String? eventLink; // Link for online events
  final bool isPaid;
  final double? amount; // Amount if paid event
  ClubEventModel({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.clubId,
    this.imageUrl,
    this.isOnline = false,
    this.eventLink,
    this.isPaid = false,
    this.amount,
  });

  ClubEventModel copyWith({
    String? id,
    String? title,
    Object? startDate,
    Object? endDate,
    String? location,
    String? clubId,
    String? imageUrl,
    bool? isOnline,
    String? eventLink,
    bool? isPaid,
    double? amount,
  }) {
    return ClubEventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      location: location ?? this.location,
      clubId: clubId ?? this.clubId,
      imageUrl: imageUrl ?? this.imageUrl,
      isOnline: isOnline ?? this.isOnline,
      eventLink: eventLink ?? this.eventLink,
      isPaid: isPaid ?? this.isPaid,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'startDate': startDate,
      'endDate': endDate,
      'location': location,
      'clubId': clubId,
      'imageUrl': imageUrl,
      'isOnline': isOnline,
      'eventLink': eventLink,
      'isPaid': isPaid,
      'amount': amount,
    };
  }

  // from firestore
  factory ClubEventModel.fromFirestore(DocumentSnapshot snapshot) {
    final json = snapshot.data() as Map<String, dynamic>;
    if (json.isEmpty) {
      throw Exception('ClubEvent data is empty');
    }
    return ClubEventModel.fromMap(json);
  }

  factory ClubEventModel.fromMap(Map<String, dynamic> map) {
    return ClubEventModel(
      id: map['id'] as String,
      title: map['title'] as String,
      startDate: map['startDate'].toDate(),
      endDate: map['endDate'].toDate(),
      location: map['location'] as String,
      clubId: map['clubId'] as String,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      isOnline: map['isOnline'] as bool? ?? false,
      eventLink: map['eventLink'] != null ? map['eventLink'] as String : null,
      isPaid: map['isPaid'] as bool? ?? false,
      amount: map['amount'] != null ? (map['amount'] as num).toDouble() : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ClubEventModel.fromJson(String source) =>
      ClubEventModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ClubEventModel(id: $id, title: $title, startDate: $startDate, endDate: $endDate, location: $location, clubId: $clubId, imageUrl: $imageUrl, isOnline: $isOnline, eventLink: $eventLink, isPaid: $isPaid, amount: $amount)';
  }

  @override
  bool operator ==(covariant ClubEventModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.location == location &&
        other.clubId == clubId &&
        other.imageUrl == imageUrl &&
        other.isOnline == isOnline &&
        other.eventLink == eventLink &&
        other.isPaid == isPaid &&
        other.amount == amount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        location.hashCode ^
        clubId.hashCode ^
        imageUrl.hashCode ^
        isOnline.hashCode ^
        eventLink.hashCode ^
        isPaid.hashCode ^
        amount.hashCode;
  }
}
