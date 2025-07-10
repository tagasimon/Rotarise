// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class VisitModel {
  final String id;
  final String userId;
  final String clubId;
  final String visitedClubId;
  final String visitedClubName;
  final double latitude;
  final double longitude;
  final DateTime visitDate;
  VisitModel({
    required this.id,
    required this.userId,
    required this.clubId,
    required this.visitedClubId,
    required this.visitedClubName,
    required this.latitude,
    required this.longitude,
    required this.visitDate,
  });

  VisitModel copyWith({
    String? id,
    String? userId,
    String? clubId,
    String? visitedClubId,
    String? visitedClubName,
    double? latitude,
    double? longitude,
    DateTime? visitDate,
  }) {
    return VisitModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      clubId: clubId ?? this.clubId,
      visitedClubId: visitedClubId ?? this.visitedClubId,
      visitedClubName: visitedClubName ?? this.visitedClubName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      visitDate: visitDate ?? this.visitDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'clubId': clubId,
      'visitedClubId': visitedClubId,
      'visitedClubName': visitedClubName,
      'latitude': latitude,
      'longitude': longitude,
      'visitDate': visitDate,
    };
  }

  // from fire
  factory VisitModel.fromFirestore(DocumentSnapshot snapshot) {
    final json = snapshot.data() as Map<String, dynamic>;
    if (json.isEmpty) {
      throw Exception('VisitModel data is empty');
    }
    return VisitModel.fromMap(json);
  }

  factory VisitModel.fromMap(Map<String, dynamic> map) {
    return VisitModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      clubId: map['clubId'] as String,
      visitedClubId: map['visitedClubId'] as String,
      visitedClubName: map['visitedClubName'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      visitDate: map['visitDate'].toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory VisitModel.fromJson(String source) =>
      VisitModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VisitModel(id: $id, userId: $userId, clubId: $clubId, visitedClubId: $visitedClubId, visitedClubName: $visitedClubName, latitude: $latitude, longitude: $longitude, visitDate: $visitDate)';
  }

  @override
  bool operator ==(covariant VisitModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.clubId == clubId &&
        other.visitedClubId == visitedClubId &&
        other.visitedClubName == visitedClubName &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.visitDate == visitDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        clubId.hashCode ^
        visitedClubId.hashCode ^
        visitedClubName.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        visitDate.hashCode;
  }
}
