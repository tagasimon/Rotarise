// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ClubRole {
  final String id;
  final String clubId;
  final String roleTitle;
  final String? roleDescription;
  final bool isActive;
  final List<dynamic> responsibilities;
  final Object createdAt;
  ClubRole({
    required this.id,
    required this.clubId,
    required this.roleTitle,
    this.roleDescription,
    required this.isActive,
    required this.responsibilities,
    required this.createdAt,
  });

  ClubRole copyWith({
    String? id,
    String? clubId,
    String? roleTitle,
    String? roleDescription,
    bool? isActive,
    List<dynamic>? responsibilities,
    Object? createdAt,
  }) {
    return ClubRole(
      id: id ?? this.id,
      clubId: clubId ?? this.clubId,
      roleTitle: roleTitle ?? this.roleTitle,
      roleDescription: roleDescription ?? this.roleDescription,
      isActive: isActive ?? this.isActive,
      responsibilities: responsibilities ?? this.responsibilities,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'clubId': clubId,
      'roleTitle': roleTitle,
      'roleDescription': roleDescription,
      'isActive': isActive,
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
    if (map.isEmpty) {
      throw Exception('ClubRole data is empty');
    }
    return ClubRole(
      id: map['id'] as String,
      roleTitle: map['roleTitle'] as String,
      clubId: map['clubId'] as String,
      roleDescription: map['roleDescription'] != null
          ? map['roleDescription'] as String
          : null,
      isActive: map['isActive'] as bool,
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
    return 'ClubRole(id: $id, clubId: $clubId, roleTitle: $roleTitle, roleDescription: $roleDescription, isActive: $isActive, responsibilities: $responsibilities, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant ClubRole other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.clubId == clubId &&
        other.roleTitle == roleTitle &&
        other.roleDescription == roleDescription &&
        other.isActive == isActive &&
        listEquals(other.responsibilities, responsibilities) &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        clubId.hashCode ^
        roleTitle.hashCode ^
        roleDescription.hashCode ^
        isActive.hashCode ^
        responsibilities.hashCode ^
        createdAt.hashCode;
  }
}
