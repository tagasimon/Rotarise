// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class LikeModel {
  final String id;
  final String postId;
  final String userId;
  final DateTime likedAt;
  LikeModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.likedAt,
  });

  LikeModel copyWith({
    String? id,
    String? postId,
    String? userId,
    DateTime? likedAt,
  }) {
    return LikeModel(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      likedAt: likedAt ?? this.likedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'postId': postId,
      'userId': userId,
      'likedAt': likedAt.millisecondsSinceEpoch,
    };
  }

  factory LikeModel.fromFirestore(DocumentSnapshot snapshot) {
    final json = snapshot.data() as Map<String, dynamic>;
    if (json.isEmpty) {
      throw Exception('LikeModel data is empty');
    }
    return LikeModel.fromMap(json);
  }

  factory LikeModel.fromMap(Map<String, dynamic> map) {
    return LikeModel(
      id: map['id'] as String,
      postId: map['postId'] as String,
      userId: map['userId'] as String,
      likedAt: map['likedAt'].toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory LikeModel.fromJson(String source) =>
      LikeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LikeModel(id: $id, postId: $postId, userId: $userId, likedAt: $likedAt)';
  }

  @override
  bool operator ==(covariant LikeModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.postId == postId &&
        other.userId == userId &&
        other.likedAt == likedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ postId.hashCode ^ userId.hashCode ^ likedAt.hashCode;
  }
}
