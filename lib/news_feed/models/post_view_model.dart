// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// This will be PostViewModel used to count the number of views for a post
// It will be used in the PostsSliverSection to display the number of views for each
class PostViewModel {
  final String id;
  final String postId;
  final String viewerId;
  final DateTime viewedAt;

  PostViewModel({
    required this.id,
    required this.postId,
    required this.viewerId,
    required this.viewedAt,
  });

  PostViewModel copyWith({
    String? id,
    String? postId,
    String? viewerId,
    DateTime? viewedAt,
  }) {
    return PostViewModel(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      viewerId: viewerId ?? this.viewerId,
      viewedAt: viewedAt ?? this.viewedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'postId': postId,
      'viewerId': viewerId,
      'viewedAt': viewedAt.millisecondsSinceEpoch,
    };
  }

  factory PostViewModel.fromMap(Map<String, dynamic> map) {
    return PostViewModel(
      id: map['id'] as String,
      postId: map['postId'] as String,
      viewerId: map['viewerId'] as String,
      viewedAt: DateTime.fromMillisecondsSinceEpoch(map['viewedAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory PostViewModel.fromJson(String source) =>
      PostViewModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PostViewModel(id: $id, postId: $postId, viewerId: $viewerId, viewedAt: $viewedAt)';
  }

  @override
  bool operator ==(covariant PostViewModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.postId == postId &&
        other.viewerId == viewerId &&
        other.viewedAt == viewedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        postId.hashCode ^
        viewerId.hashCode ^
        viewedAt.hashCode;
  }
}
