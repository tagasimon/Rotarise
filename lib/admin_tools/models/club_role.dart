// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ClubRole {
  final String id;
  final String clubId;
  final String title;
  final String? description;
  final List<dynamic> responsibilities;
  final Object createdAt;
  ClubRole({
    required this.id,
    required this.clubId,
    required this.title,
    this.description,
    required this.responsibilities,
    required this.createdAt,
  });

  ClubRole copyWith({
    String? id,
    String? clubId,
    String? title,
    String? description,
    List<dynamic>? responsibilities,
    Object? createdAt,
  }) {
    return ClubRole(
      id: id ?? this.id,
      clubId: clubId ?? this.clubId,
      title: title ?? this.title,
      description: description ?? this.description,
      responsibilities: responsibilities ?? this.responsibilities,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'clubId': clubId,
      'title': title,
      'description': description,
      'responsibilities': responsibilities,
      'createdAt': createdAt,
    };
  }

  // from firestore
  factory ClubRole.fromFirestore(DocumentSnapshot snapshot) {
    final json = snapshot.data() as Map<String, dynamic>;
    if (json.isEmpty) {
      throw Exception('ClubRole data is empty');
    }
    return ClubRole.fromMap(json);
  }

  factory ClubRole.fromMap(Map<String, dynamic> map) {
    return ClubRole(
      id: map['id'] as String,
      clubId: map['clubId'] as String,
      title: map['title'] as String,
      description:
          map['description'] != null ? map['description'] as String : null,
      responsibilities:
          List<dynamic>.from((map['responsibilities'] as List<dynamic>)),
      createdAt: map['createdAt'].toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ClubRole.fromJson(String source) =>
      ClubRole.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ClubRole(id: $id, clubId: $clubId, title: $title, description: $description, responsibilities: $responsibilities, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant ClubRole other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.clubId == clubId &&
        other.title == title &&
        other.description == description &&
        listEquals(other.responsibilities, responsibilities) &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        clubId.hashCode ^
        title.hashCode ^
        description.hashCode ^
        responsibilities.hashCode ^
        createdAt.hashCode;
  }
}
