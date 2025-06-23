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
  ClubEventModel({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.clubId,
    this.imageUrl,
  });

  ClubEventModel copyWith({
    String? id,
    String? title,
    Object? startDate,
    Object? endDate,
    String? location,
    String? clubId,
    String? imageUrl,
  }) {
    return ClubEventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      location: location ?? this.location,
      clubId: clubId ?? this.clubId,
      imageUrl: imageUrl ?? this.imageUrl,
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
    );
  }

  String toJson() => json.encode(toMap());

  factory ClubEventModel.fromJson(String source) =>
      ClubEventModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ClubEventModel(id: $id, title: $title, startDate: $startDate, endDate: $endDate, location: $location, clubId: $clubId, imageUrl: $imageUrl)';
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
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        location.hashCode ^
        clubId.hashCode ^
        imageUrl.hashCode;
  }
}
