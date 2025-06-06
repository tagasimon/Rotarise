// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:rotaract/projects/models/project_donation.dart';
import 'package:rotaract/projects/models/project_image.dart';
import 'package:rotaract/projects/models/project_impact.dart';
import 'package:rotaract/projects/models/project_update.dart';

class ProjectModel {
  final String id;
  final String clubId;
  final String title;
  final String description;
  final double? target;
  final List<ProjectDonation>? donations;
  final List<ProjectImage>? gallery;
  final List<ProjectImpact>? impactList;
  final List<ProjectUpdate>? updates;
  final DateTime startDate;

  ProjectModel({
    required this.id,
    required this.clubId,
    required this.title,
    required this.description,
    this.target,
    this.donations,
    this.gallery,
    this.impactList,
    this.updates,
    required this.startDate,
  });

  factory ProjectModel.fromFirestore(DocumentSnapshot snapshot) {
    final json = snapshot.data() as Map<String, dynamic>;
    if (json.isEmpty) {
      throw Exception('Project data is empty');
    }
    return ProjectModel.fromMap(json);
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) {
      throw Exception('Project data is empty');
    }
    return ProjectModel(
      id: map['id'] as String? ?? '',
      clubId: map['clubId'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      target: map['target'] != null ? (map['target'] as num).toDouble() : null,
      donations: (map['donations'] as List<dynamic>?)
          ?.map((e) => ProjectDonation.fromMap(e as Map<String, dynamic>))
          .toList(),
      gallery: (map['gallery'] as List<dynamic>?)
          ?.map((e) => ProjectImage.fromMap(e as Map<String, dynamic>))
          .toList(),
      impactList: (map['impactList'] as List<dynamic>?)
          ?.map((e) => ProjectImpact.fromMap(e as Map<String, dynamic>))
          .toList(),
      updates: (map['updates'] as List<dynamic>?)
          ?.map((e) => ProjectUpdate.fromMap(e as Map<String, dynamic>))
          .toList(),
      startDate: map['startDate'] is Timestamp
          ? (map['startDate'] as Timestamp).toDate()
          : DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clubId': clubId,
      'title': title,
      'description': description,
      'target': target,
      'donations': donations?.map((e) => e.toMap()).toList(),
      'gallery': gallery?.map((e) => e.toMap()).toList(),
      'impactList': impactList?.map((e) => e.toMap()).toList(),
      'updates': updates?.map((e) => e.toMap()).toList(),
      'startDate': startDate.millisecondsSinceEpoch,
    };
  }

  String toJson() => json.encode(toMap());

  factory ProjectModel.fromJson(String source) =>
      ProjectModel.fromMap(json.decode(source) as Map<String, dynamic>);

  ProjectModel copyWith({
    String? id,
    String? clubId,
    String? title,
    String? description,
    double? target,
    List<ProjectDonation>? donations,
    List<ProjectImage>? gallery,
    List<ProjectImpact>? impactList,
    List<ProjectUpdate>? updates,
    DateTime? startDate,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      clubId: clubId ?? this.clubId,
      title: title ?? this.title,
      description: description ?? this.description,
      target: target ?? this.target,
      donations: donations ?? this.donations,
      gallery: gallery ?? this.gallery,
      impactList: impactList ?? this.impactList,
      updates: updates ?? this.updates,
      startDate: startDate ?? this.startDate,
    );
  }

  @override
  String toString() {
    return 'ProjectModel(id: $id, clubId: $clubId, title: $title, description: $description, target: $target, donations: $donations, gallery: $gallery, impactList: $impactList, updates: $updates, startDate: $startDate)';
  }

  @override
  bool operator ==(covariant ProjectModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.clubId == clubId &&
        other.title == title &&
        other.description == description &&
        other.target == target &&
        listEquals(other.donations, donations) &&
        listEquals(other.gallery, gallery) &&
        listEquals(other.impactList, impactList) &&
        listEquals(other.updates, updates) &&
        other.startDate == startDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        clubId.hashCode ^
        title.hashCode ^
        description.hashCode ^
        target.hashCode ^
        donations.hashCode ^
        gallery.hashCode ^
        impactList.hashCode ^
        updates.hashCode ^
        startDate.hashCode;
  }
}
