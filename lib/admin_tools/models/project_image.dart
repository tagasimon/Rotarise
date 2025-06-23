// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProjectImage {
  final String id;
  final String projectId;
  final String url;
  final String? caption;
  ProjectImage({
    required this.id,
    required this.projectId,
    required this.url,
    this.caption,
  });

  ProjectImage copyWith({
    String? id,
    String? projectId,
    String? url,
    String? caption,
  }) {
    return ProjectImage(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      url: url ?? this.url,
      caption: caption ?? this.caption,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'projectId': projectId,
      'url': url,
      'caption': caption,
    };
  }

  factory ProjectImage.fromMap(Map<String, dynamic> map) {
    return ProjectImage(
      id: map['id'] as String,
      projectId: map['projectId'] as String,
      url: map['url'] as String,
      caption: map['caption'] != null ? map['caption'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProjectImage.fromJson(String source) =>
      ProjectImage.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProjectImage(id: $id, projectId: $projectId, url: $url, caption: $caption)';
  }

  @override
  bool operator ==(covariant ProjectImage other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.projectId == projectId &&
        other.url == url &&
        other.caption == caption;
  }

  @override
  int get hashCode {
    return id.hashCode ^ projectId.hashCode ^ url.hashCode ^ caption.hashCode;
  }
}
