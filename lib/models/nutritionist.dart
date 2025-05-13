// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Nutritionist {
  final String name;
  final String title;
  final String specialization;
  final String education;
  final String imageUrl;
  final String description;
  Nutritionist({
    required this.name,
    required this.title,
    required this.specialization,
    required this.education,
    required this.imageUrl,
    required this.description,
  });

  Nutritionist copyWith({
    String? name,
    String? title,
    String? specialization,
    String? education,
    String? imageUrl,
    String? description,
  }) {
    return Nutritionist(
      name: name ?? this.name,
      title: title ?? this.title,
      specialization: specialization ?? this.specialization,
      education: education ?? this.education,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'title': title,
      'specialization': specialization,
      'education': education,
      'imageUrl': imageUrl,
      'description': description,
    };
  }

  factory Nutritionist.fromMap(Map<String, dynamic> map) {
    return Nutritionist(
      name: map['name'] as String,
      title: map['title'] as String,
      specialization: map['specialization'] as String,
      education: map['education'] as String,
      imageUrl: map['imageUrl'] as String,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Nutritionist.fromJson(String source) =>
      Nutritionist.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Nutritionist(name: $name, title: $title, specialization: $specialization, education: $education, imageUrl: $imageUrl, description: $description)';
  }

  @override
  bool operator ==(covariant Nutritionist other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.title == title &&
        other.specialization == specialization &&
        other.education == education &&
        other.imageUrl == imageUrl &&
        other.description == description;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        title.hashCode ^
        specialization.hashCode ^
        education.hashCode ^
        imageUrl.hashCode ^
        description.hashCode;
  }
}
