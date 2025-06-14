// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id;
  final String userId;
  final String comment;
  final DateTime date;
  CommentModel({
    required this.id,
    required this.userId,
    required this.comment,
    required this.date,
  });

  CommentModel copyWith({
    String? id,
    String? userId,
    String? comment,
    DateTime? date,
  }) {
    return CommentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      comment: comment ?? this.comment,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'comment': comment,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory CommentModel.fromFirestore(DocumentSnapshot snapshot) {
    final json = snapshot.data() as Map<String, dynamic>;
    if (json.isEmpty) {
      throw Exception('CommentModel data is empty');
    }
    return CommentModel.fromMap(json);
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      comment: map['comment'] as String,
      date: map['date'].toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CommentModel(id: $id, userId: $userId, comment: $comment, date: $date)';
  }

  @override
  bool operator ==(covariant CommentModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.comment == comment &&
        other.date == date;
  }

  @override
  int get hashCode {
    return id.hashCode ^ userId.hashCode ^ comment.hashCode ^ date.hashCode;
  }
}
