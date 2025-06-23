// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProjectImpact {
  final String id;
  final String title;
  final String value;
  final String? desc;
  ProjectImpact({
    required this.id,
    required this.title,
    required this.value,
    this.desc,
  });

  ProjectImpact copyWith({
    String? id,
    String? title,
    String? value,
    String? desc,
  }) {
    return ProjectImpact(
      id: id ?? this.id,
      title: title ?? this.title,
      value: value ?? this.value,
      desc: desc ?? this.desc,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'value': value,
      'desc': desc,
    };
  }

  factory ProjectImpact.fromMap(Map<String, dynamic> map) {
    return ProjectImpact(
      id: map['id'] as String,
      title: map['title'] as String,
      value: map['value'] as String,
      desc: map['desc'] != null ? map['desc'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProjectImpact.fromJson(String source) =>
      ProjectImpact.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProjectImpact(id: $id, title: $title, value: $value, desc: $desc)';
  }

  @override
  bool operator ==(covariant ProjectImpact other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.value == value &&
        other.desc == desc;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ value.hashCode ^ desc.hashCode;
  }
}
