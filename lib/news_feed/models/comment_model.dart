// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id;
  final String postId;
  final String userId;
  final String comment;
  final DateTime date;
  final String userName;
  final String userAvatarUrl;
  CommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.comment,
    required this.date,
    required this.userName,
    required this.userAvatarUrl,
  });

  CommentModel copyWith({
    String? id,
    String? postId,
    String? userId,
    String? comment,
    DateTime? date,
    String? userName,
    String? userAvatarUrl,
  }) {
    return CommentModel(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      comment: comment ?? this.comment,
      date: date ?? this.date,
      userName: userName ?? this.userName,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'postId': postId,
      'userId': userId,
      'comment': comment,
      'date': date,
      'userName': userName,
      'userAvatarUrl': userAvatarUrl,
    };
  }

  factory CommentModel.fromFirestore(DocumentSnapshot snapshot) {
    final json = snapshot.data() as Map<String, dynamic>;
    if (json.isEmpty) {
      throw Exception('CommentModal data is empty');
    }
    return CommentModel.fromMap(json);
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] as String,
      postId: map['postId'] as String,
      userId: map['userId'] as String,
      comment: map['comment'] as String,
      date: map['date'].toDate(),
      userName: map['userName'] as String,
      userAvatarUrl: map['userAvatarUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CommentModel(id: $id, postId: $postId, userId: $userId, comment: $comment, date: $date, userName: $userName, userAvatarUrl: $userAvatarUrl)';
  }

  @override
  bool operator ==(covariant CommentModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.postId == postId &&
        other.userId == userId &&
        other.comment == comment &&
        other.date == date &&
        other.userName == userName &&
        other.userAvatarUrl == userAvatarUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        postId.hashCode ^
        userId.hashCode ^
        comment.hashCode ^
        date.hashCode ^
        userName.hashCode ^
        userAvatarUrl.hashCode;
  }
}
