// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class BuddyGroupModel {
  final String id;
  final String clubId;
  final String name;
  final String addedBy;
  final String? description;
  final String? imageUrl;
  BuddyGroupModel({
    required this.id,
    required this.clubId,
    required this.name,
    required this.addedBy,
    this.description,
    this.imageUrl,
  });

  BuddyGroupModel copyWith({
    String? id,
    String? clubId,
    String? name,
    String? addedBy,
    String? description,
    String? imageUrl,
  }) {
    return BuddyGroupModel(
      id: id ?? this.id,
      clubId: clubId ?? this.clubId,
      name: name ?? this.name,
      addedBy: addedBy ?? this.addedBy,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'clubId': clubId,
      'name': name,
      'addedBy': addedBy,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  factory BuddyGroupModel.fromFirestore(DocumentSnapshot snapshot) {
    final json = snapshot.data() as Map<String, dynamic>;
    if (json.isEmpty) {
      throw Exception('BuddyGroupModel data is empty');
    }
    return BuddyGroupModel.fromMap(json);
  }

  factory BuddyGroupModel.fromMap(Map<String, dynamic> map) {
    return BuddyGroupModel(
      id: map['id'] as String,
      clubId: map['clubId'] as String,
      name: map['name'] as String,
      addedBy: map['addedBy'] as String,
      description:
          map['description'] != null ? map['description'] as String : null,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BuddyGroupModel.fromJson(String source) =>
      BuddyGroupModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BuddyGroupModel(id: $id, clubId: $clubId, name: $name, addedBy: $addedBy, description: $description, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(covariant BuddyGroupModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.clubId == clubId &&
        other.name == name &&
        other.addedBy == addedBy &&
        other.description == description &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        clubId.hashCode ^
        name.hashCode ^
        addedBy.hashCode ^
        description.hashCode ^
        imageUrl.hashCode;
  }
}
