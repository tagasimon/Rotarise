// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class VisitModel {
  final String id;
  final String userId;
  final String clubId;
  final String visitDesc;
  final String visitedClubId;
  final String visitedClubName;
  final DateTime visitDate;
  final double? latitude;
  final double? longitude;
  final String imageUrl;
  VisitModel({
    required this.id,
    required this.userId,
    required this.clubId,
    required this.visitDesc,
    required this.visitedClubId,
    required this.visitedClubName,
    required this.visitDate,
    this.latitude,
    this.longitude,
    required this.imageUrl,
  });

  VisitModel copyWith({
    String? id,
    String? userId,
    String? clubId,
    String? visitDesc,
    String? visitedClubId,
    String? visitedClubName,
    DateTime? visitDate,
    double? latitude,
    double? longitude,
    String? imageUrl,
  }) {
    return VisitModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      clubId: clubId ?? this.clubId,
      visitDesc: visitDesc ?? this.visitDesc,
      visitedClubId: visitedClubId ?? this.visitedClubId,
      visitedClubName: visitedClubName ?? this.visitedClubName,
      visitDate: visitDate ?? this.visitDate,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'clubId': clubId,
      'visitDesc': visitDesc,
      'visitedClubId': visitedClubId,
      'visitedClubName': visitedClubName,
      'visitDate': visitDate.millisecondsSinceEpoch,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrl': imageUrl,
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
      visitDesc: map['visitDesc'] as String,
      visitedClubId: map['visitedClubId'] as String,
      visitedClubName: map['visitedClubName'] as String,
      visitDate: DateTime.fromMillisecondsSinceEpoch(map['visitDate'] as int),
      latitude: map['latitude'] != null ? map['latitude'] as double : null,
      longitude: map['longitude'] != null ? map['longitude'] as double : null,
      imageUrl: map['imageUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory VisitModel.fromJson(String source) =>
      VisitModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VisitModel(id: $id, userId: $userId, clubId: $clubId, visitDesc: $visitDesc, visitedClubId: $visitedClubId, visitedClubName: $visitedClubName, visitDate: $visitDate, latitude: $latitude, longitude: $longitude, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(covariant VisitModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.clubId == clubId &&
        other.visitDesc == visitDesc &&
        other.visitedClubId == visitedClubId &&
        other.visitedClubName == visitedClubName &&
        other.visitDate == visitDate &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        clubId.hashCode ^
        visitDesc.hashCode ^
        visitedClubId.hashCode ^
        visitedClubName.hashCode ^
        visitDate.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        imageUrl.hashCode;
  }
}
