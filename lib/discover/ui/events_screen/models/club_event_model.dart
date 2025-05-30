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
  final String? inCharge;
  ClubEventModel({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.clubId,
    this.imageUrl,
    this.inCharge,
  });

  ClubEventModel copyWith({
    String? id,
    String? title,
    Object? startDate,
    Object? endDate,
    String? location,
    String? clubId,
    String? imageUrl,
    String? inCharge,
  }) {
    return ClubEventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      location: location ?? this.location,
      clubId: clubId ?? this.clubId,
      imageUrl: imageUrl ?? this.imageUrl,
      inCharge: inCharge ?? this.inCharge,
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
      'inCharge': inCharge,
    };
  }

  factory ClubEventModel.fromMap(DocumentSnapshot snapshot) {
    final map = snapshot.data() as Map<String, dynamic>;
    return ClubEventModel(
      id: map['id'] as String,
      title: map['title'] as String,
      startDate: map['startDate'].toDate(),
      endDate: map['endDate'].toDate(),
      location: map['location'] as String,
      clubId: map['clubId'] as String,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      inCharge: map['inCharge'] != null ? map['inCharge'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ClubEventModel.fromJson(String source) =>
      ClubEventModel.fromMap(json.decode(source) as DocumentSnapshot);

  @override
  String toString() {
    return 'ClubEventModel(id: $id, title: $title, startDate: $startDate, endDate: $endDate, location: $location, clubId: $clubId, imageUrl: $imageUrl, inCharge: $inCharge)';
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
        other.inCharge == inCharge;
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
        inCharge.hashCode;
  }
}
