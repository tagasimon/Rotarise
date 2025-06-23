// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProjectUpdate {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String? imageUrl;
  final String? videoUrl;
  ProjectUpdate({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.imageUrl,
    this.videoUrl,
  });

  ProjectUpdate copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    String? imageUrl,
    String? videoUrl,
  }) {
    return ProjectUpdate(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'date': date.millisecondsSinceEpoch,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
    };
  }

  factory ProjectUpdate.fromMap(Map<String, dynamic> map) {
    return ProjectUpdate(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      videoUrl: map['videoUrl'] != null ? map['videoUrl'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProjectUpdate.fromJson(String source) =>
      ProjectUpdate.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProjectUpdate(id: $id, title: $title, description: $description, date: $date, imageUrl: $imageUrl, videoUrl: $videoUrl)';
  }

  @override
  bool operator ==(covariant ProjectUpdate other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        other.date == date &&
        other.imageUrl == imageUrl &&
        other.videoUrl == videoUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        date.hashCode ^
        imageUrl.hashCode ^
        videoUrl.hashCode;
  }
}
