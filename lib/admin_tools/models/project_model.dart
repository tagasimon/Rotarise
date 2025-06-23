// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  final String id;
  final String clubId;
  final String title;
  final String description;
  final Object? startDate;
  final String? coverImg;
  final double? target;
  final Object date;
  ProjectModel({
    required this.id,
    required this.clubId,
    required this.title,
    required this.description,
    this.startDate,
    this.coverImg,
    this.target,
    required this.date,
  });

  ProjectModel copyWith({
    String? id,
    String? clubId,
    String? title,
    String? description,
    Object? startDate,
    String? coverImg,
    double? target,
    Object? date,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      clubId: clubId ?? this.clubId,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      coverImg: coverImg ?? this.coverImg,
      target: target ?? this.target,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'clubId': clubId,
      'title': title,
      'description': description,
      'startDate': startDate,
      'coverImg': coverImg,
      'target': target,
      'date': date,
    };
  }

  factory ProjectModel.fromFirestore(DocumentSnapshot snapshot) {
    final json = snapshot.data() as Map<String, dynamic>;
    if (json.isEmpty) {
      throw Exception('ClubModel data is empty');
    }
    return ProjectModel.fromMap(json);
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      id: map['id'] as String,
      clubId: map['clubId'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      startDate: map['startDate']?.toDate(),
      coverImg: map['coverImg'] != null ? map['coverImg'] as String : null,
      target: map['target'] != null ? map['target'] as double : null,
      date: map['date']?.toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProjectModel.fromJson(String source) =>
      ProjectModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProjectModel(id: $id, clubId: $clubId, title: $title, description: $description, startDate: $startDate, coverImg: $coverImg, target: $target, date: $date)';
  }

  @override
  bool operator ==(covariant ProjectModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.clubId == clubId &&
        other.title == title &&
        other.description == description &&
        other.startDate == startDate &&
        other.coverImg == coverImg &&
        other.target == target &&
        other.date == date;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        clubId.hashCode ^
        title.hashCode ^
        description.hashCode ^
        startDate.hashCode ^
        coverImg.hashCode ^
        target.hashCode ^
        date.hashCode;
  }
}
