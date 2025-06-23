import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rotaract/_constants/constants.dart';
import 'package:rotaract/admin_tools/models/project_donation.dart';
import 'package:rotaract/admin_tools/models/project_image.dart';
import 'package:rotaract/admin_tools/models/project_impact.dart';
import 'package:rotaract/admin_tools/models/project_update.dart';

class ProjectModel {
  final String id;
  final String clubId;
  final String title;
  final String description;
  final String? coverImg;
  final double? target;
  final List<ProjectDonation>? donations;
  final List<ProjectImage>? gallery;
  final List<ProjectImpact>? impactList;
  final List<ProjectUpdate>? updates;
  final DateTime? startDate;
  final DateTime date;

  const ProjectModel({
    required this.id,
    required this.clubId,
    required this.title,
    required this.description,
    this.coverImg,
    this.target,
    this.donations,
    this.gallery,
    this.impactList,
    this.updates,
    this.startDate,
    required this.date,
  });

  factory ProjectModel.fromFirestore(DocumentSnapshot snapshot) {
    final json = snapshot.data() as Map<String, dynamic>;
    if (json.isEmpty) {
      throw Exception('Project data is empty');
    }
    return ProjectModel.fromMap(json);
  }

  // Factory constructor for creating ProjectModel from JSON
  factory ProjectModel.fromMap(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String,
      clubId: json['clubId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      target: json['target']?.toDouble(),
      coverImg: json['coverImg'] ?? Constants.kDefaultImageLink,
      donations: json['donations'] != null
          ? (json['donations'] as List)
              .map((item) => ProjectDonation.fromJson(item))
              .toList()
          : null,
      gallery: json['gallery'] != null
          ? (json['gallery'] as List)
              .map((item) => ProjectImage.fromJson(item))
              .toList()
          : null,
      impactList: json['impactList'] != null
          ? (json['impactList'] as List)
              .map((item) => ProjectImpact.fromJson(item))
              .toList()
          : null,
      updates: json['updates'] != null
          ? (json['updates'] as List)
              .map((item) => ProjectUpdate.fromJson(item))
              .toList()
          : null,
      startDate: json['startDate']?.toDate(),
      date: json['date']?.toDate(),
    );
  }

  // Method to convert ProjectModel to JSON
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clubId': clubId,
      'title': title,
      'description': description,
      'target': target,
      'coverImg': coverImg,
      'donations': donations?.map((item) => item.toJson()).toList(),
      'gallery': gallery?.map((item) => item.toJson()).toList(),
      'impactList': impactList?.map((item) => item.toJson()).toList(),
      'updates': updates?.map((item) => item.toJson()).toList(),
      'startDate': startDate,
      'date': date,
    };
  }

  String toJson() => json.encode(toMap());

  // CopyWith method for creating modified copies
  ProjectModel copyWith({
    String? id,
    String? clubId,
    String? title,
    String? description,
    double? target,
    String? coverImg,
    List<ProjectDonation>? donations,
    List<ProjectImage>? gallery,
    List<ProjectImpact>? impactList,
    List<ProjectUpdate>? updates,
    DateTime? startDate,
    DateTime? date,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      clubId: clubId ?? this.clubId,
      title: title ?? this.title,
      description: description ?? this.description,
      target: target ?? this.target,
      coverImg: coverImg ?? this.coverImg,
      donations: donations ?? this.donations,
      gallery: gallery ?? this.gallery,
      impactList: impactList ?? this.impactList,
      updates: updates ?? this.updates,
      startDate: startDate ?? this.startDate,
      date: date ?? this.date,
    );
  }

  // Equality operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ProjectModel) return false;

    return id == other.id &&
        clubId == other.clubId &&
        title == other.title &&
        description == other.description &&
        target == other.target &&
        coverImg == other.coverImg &&
        _listEquals(donations, other.donations) &&
        _listEquals(gallery, other.gallery) &&
        _listEquals(impactList, other.impactList) &&
        _listEquals(updates, other.updates) &&
        startDate == other.startDate &&
        date == other.date;
  }

  // Helper method for comparing lists
  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  // Hash code
  @override
  int get hashCode {
    return Object.hash(
      id,
      clubId,
      title,
      description,
      target,
      donations,
      gallery,
      impactList,
      updates,
      startDate,
      date,
    );
  }

  // toString method
  @override
  String toString() {
    return 'ProjectModel(id: $id, clubId: $clubId, title: $title, description: $description, target: $target, donations: $donations, gallery: $gallery, impactList: $impactList, updates: $updates, startDate: $startDate, date: $date)';
  }

  // Utility methods
  double get totalDonations {
    if (donations == null || donations!.isEmpty) return 0.0;
    return donations!.fold(0.0, (sum, donation) => sum + donation.amount);
  }

  double get progressPercentage {
    if (target == null || target == 0) return 0.0;
    return (totalDonations / target!) * 100;
  }

  bool get isCompleted {
    if (target == null) return false;
    return totalDonations >= target!;
  }

  int get donationsCount => donations?.length ?? 0;
  int get imagesCount => gallery?.length ?? 0;
  int get impactsCount => impactList?.length ?? 0;
  int get updatesCount => updates?.length ?? 0;
}
