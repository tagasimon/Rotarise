// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rotaract/_constants/constants.dart';

class PostModel {
  final String id;
  final String authorId;
  final String clubId;
  final DateTime timestamp;
  final String? authorName;
  final String? authorAvatar;
  final String? content;
  final String? clubName;
  final int? likesCount;
  final int? commentsCount;
  final int? reportsCount;
  final int viewCount;
  final String? imageUrl;
  final String? videoUrl;
  final List<String>? taggedClubIds;
  PostModel({
    required this.id,
    required this.authorId,
    required this.clubId,
    this.authorName,
    this.authorAvatar,
    this.content,
    required this.timestamp,
    this.clubName,
    this.likesCount,
    this.commentsCount,
    this.reportsCount,
    this.viewCount = 0,
    this.imageUrl,
    this.videoUrl,
    this.taggedClubIds,
  });

  PostModel copyWith({
    String? id,
    String? authorId,
    String? clubId,
    String? authorName,
    String? authorAvatar,
    String? content,
    DateTime? timestamp,
    String? clubName,
    int? likesCount,
    int? commentsCount,
    int? reportsCount,
    int? viewCount,
    String? imageUrl,
    String? videoUrl,
    List<String>? taggedClubIds,
  }) {
    return PostModel(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      clubId: clubId ?? this.clubId,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      clubName: clubName ?? this.clubName,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      reportsCount: reportsCount ?? this.reportsCount,
      viewCount: viewCount ?? this.viewCount,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      taggedClubIds: taggedClubIds ?? this.taggedClubIds,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'authorId': authorId,
      'clubId': clubId,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'content': content,
      'timestamp': timestamp,
      'clubName': clubName,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'reportsCount': reportsCount,
      'viewCount': viewCount,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'taggedClubIds': taggedClubIds,
    };
  }

  factory PostModel.fromFirestore(DocumentSnapshot snapshot) {
    final json = snapshot.data() as Map<String, dynamic>;
    if (json.isEmpty) {
      throw Exception('PostModel data is empty');
    }
    return PostModel.fromMap(json);
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] as String,
      authorId: map['authorId'] as String,
      clubId: map['clubId'] as String,
      timestamp: map['timestamp'].toDate(),
      authorName: map['authorName'] ?? "",
      authorAvatar: map['authorAvatar'] ?? Constants.kDefaultImageLink,
      content: map['content'] ?? "",
      clubName: map['clubName'] ?? "",
      likesCount: map['likesCount'] != null ? map['likesCount'] as int : null,
      commentsCount:
          map['commentsCount'] != null ? map['commentsCount'] as int : null,
      reportsCount:
          map['reportsCount'] != null ? map['reportsCount'] as int : null,
      viewCount: map['viewCount'] != null ? map['viewCount'] as int : 0,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      videoUrl: map['videoUrl'] != null ? map['videoUrl'] as String : null,
      taggedClubIds: map['taggedClubIds'] != null
          ? List<String>.from(map['taggedClubIds'] as List)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PostModel(id: $id, authorId: $authorId, clubId: $clubId, authorName: $authorName, authorAvatar: $authorAvatar, content: $content, timestamp: $timestamp, clubName: $clubName, likesCount: $likesCount, commentsCount: $commentsCount, reportsCount: $reportsCount, viewCount: $viewCount, imageUrl: $imageUrl, videoUrl: $videoUrl, taggedClubIds: $taggedClubIds)';
  }

  @override
  bool operator ==(covariant PostModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.authorId == authorId &&
        other.clubId == clubId &&
        other.authorName == authorName &&
        other.authorAvatar == authorAvatar &&
        other.content == content &&
        other.timestamp == timestamp &&
        other.clubName == clubName &&
        other.likesCount == likesCount &&
        other.commentsCount == commentsCount &&
        other.reportsCount == reportsCount &&
        other.viewCount == viewCount &&
        other.imageUrl == imageUrl &&
        other.videoUrl == videoUrl &&
        _listEquals(other.taggedClubIds, taggedClubIds);
  }

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        authorId.hashCode ^
        clubId.hashCode ^
        authorName.hashCode ^
        authorAvatar.hashCode ^
        content.hashCode ^
        timestamp.hashCode ^
        clubName.hashCode ^
        likesCount.hashCode ^
        commentsCount.hashCode ^
        reportsCount.hashCode ^
        viewCount.hashCode ^
        imageUrl.hashCode ^
        videoUrl.hashCode ^
        taggedClubIds.hashCode;
  }
}
