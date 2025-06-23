// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProjectImpact {
  final String id;
  final String projectId;
  final String title;
  final double value;
  final String? desc;
  ProjectImpact({
    required this.id,
    required this.projectId,
    required this.title,
    required this.value,
    this.desc,
  });

  ProjectImpact copyWith({
    String? id,
    String? projectId,
    String? title,
    double? value,
    String? desc,
  }) {
    return ProjectImpact(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      value: value ?? this.value,
      desc: desc ?? this.desc,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'projectId': projectId,
      'title': title,
      'value': value,
      'desc': desc,
    };
  }

  factory ProjectImpact.fromMap(Map<String, dynamic> map) {
    return ProjectImpact(
      id: map['id'] as String,
      projectId: map['projectId'] as String,
      title: map['title'] as String,
      value: map['value'] as double,
      desc: map['desc'] != null ? map['desc'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProjectImpact.fromJson(String source) =>
      ProjectImpact.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProjectImpact(id: $id, projectId: $projectId, title: $title, value: $value, desc: $desc)';
  }

  @override
  bool operator ==(covariant ProjectImpact other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.projectId == projectId &&
        other.title == title &&
        other.value == value &&
        other.desc == desc;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        projectId.hashCode ^
        title.hashCode ^
        value.hashCode ^
        desc.hashCode;
  }
}
