// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Model class representing a club member
class ClubMemberModel {
  final String id;
  final String? clubId;

  /// Personal information
  final String firstName;
  final String lastName;
  final String? gender; // Consider using an enum for this
  final String? profession;
  final String? imageUrl;
  final DateTime? dateOfBirth;

  /// Contact information
  final String? email;
  final String? phoneNumber;
  final String? address;

  /// Professional information
  final String? company;
  final String? jobTitle;
  final List<String>? expertise; // Areas of professional expertise
  final List<String>? education; // Educational qualifications

  /// Membership information
  final DateTime? joinedDate;

  /// Club roles
  final String? currentClubRole; // President, Secretary, etc.
  final List<String>? previousRoles; // History of roles with dates

  ClubMemberModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.clubId,
    this.gender,
    this.profession,
    this.imageUrl,
    this.dateOfBirth,
    this.email,
    this.phoneNumber,
    this.address,
    this.company,
    this.jobTitle,
    this.expertise,
    this.education,
    this.joinedDate,
    this.currentClubRole,
    this.previousRoles,
  });

  ClubMemberModel copyWith({
    String? id,
    String? clubId,
    String? firstName,
    String? lastName,
    String? gender,
    String? profession,
    String? imageUrl,
    DateTime? dateOfBirth,
    String? email,
    String? phoneNumber,
    String? address,
    String? company,
    String? jobTitle,
    List<String>? expertise,
    List<String>? education,
    DateTime? joinedDate,
    String? currentClubRole,
    List<String>? previousRoles,
  }) {
    return ClubMemberModel(
      id: id ?? this.id,
      clubId: clubId ?? this.clubId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      profession: profession ?? this.profession,
      imageUrl: imageUrl ?? this.imageUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      company: company ?? this.company,
      jobTitle: jobTitle ?? this.jobTitle,
      expertise: expertise ?? this.expertise,
      education: education ?? this.education,
      joinedDate: joinedDate ?? this.joinedDate,
      currentClubRole: currentClubRole ?? this.currentClubRole,
      previousRoles: previousRoles ?? this.previousRoles,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'clubId': clubId,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'profession': profession,
      'imageUrl': imageUrl,
      'dateOfBirth': dateOfBirth,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'company': company,
      'jobTitle': jobTitle,
      'expertise': expertise,
      'education': education,
      'joinedDate': joinedDate,
      'currentClubRole': currentClubRole,
      'previousRoles': previousRoles,
    };
  }

  //     id: doc.id,
  //     clubId: data['clubId'] as String?,
  //     firstName: data['firstName'] as String? ?? '',
  //     lastName: data['lastName'] as String? ?? '',
  //     gender: data['gender'] as String?,
  //     profession: data['profession'] as String?,
  //     imageUrl: data['imageUrl'] as String?,
  //     dateOfBirth: data['dateOfBirth']?.toDate(),
  //     email: data['email'] as String?,
  //     phoneNumber: data['phoneNumber'] as String?,
  //     address: data['address'] as String?,
  //     company: data['company'] as String?,
  //     jobTitle: data['jobTitle'] as String?,
  //     expertise: data['expertise'] != null
  //         ? List<String>.from(data['expertise'] as List)
  //         : null,
  //     education: data['education'] != null
  //         ? List<String>.from(data['education'] as List)
  //         : null,
  //     joinedDate: data['joinedDate']?.toDate(),
  //     currentClubRole: data['currentClubRole'] as String?,
  //     previousRoles: data['previousRoles'] != null
  //         ? List<String>.from(data['previousRoles'] as List)
  //         : null,
  //   );
  // }
  // from firebase
  factory ClubMemberModel.fromFirestore(DocumentSnapshot snapshot) {
    final json = snapshot.data() as Map<String, dynamic>;
    if (json.isEmpty) {
      throw Exception('Project data is empty');
    }
    return ClubMemberModel.fromMap(json);
  }

  /// Create a MemberModel from a Map
  factory ClubMemberModel.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) {
      throw Exception('ClubMemberModel data is empty');
    }
    return ClubMemberModel(
      id: map['id'] as String? ?? '',
      clubId: map['clubId'] as String?,
      firstName: map['firstName'] as String? ?? '',
      lastName: map['lastName'] as String? ?? '',
      gender: map['gender'] as String?,
      profession: map['profession'] as String?,
      imageUrl: map['imageUrl'] as String?,
      dateOfBirth: map['dateOfBirth'] != null
          ? (map['dateOfBirth'] as Timestamp).toDate()
          : null,
      email: map['email'] as String?,
      phoneNumber: map['phoneNumber'] as String?,
      address: map['address'] as String?,
      company: map['company'] as String?,
      jobTitle: map['jobTitle'] as String?,
      expertise: map['expertise'] != null
          ? List<String>.from(map['expertise'] as List)
          : null,
      education: map['education'] != null
          ? List<String>.from(map['education'] as List)
          : null,
      joinedDate: map['joinedDate'] != null
          ? (map['joinedDate'] as Timestamp).toDate()
          : null,
      currentClubRole: map['currentClubRole'] as String?,
      previousRoles: map['previousRoles'] != null
          ? List<String>.from(map['previousRoles'] as List)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ClubMemberModel.fromJson(String source) =>
      ClubMemberModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MemberModel(id: $id, clubId: $clubId, firstName: $firstName, lastName: $lastName, gender: $gender, profession: $profession, imageUrl: $imageUrl, dateOfBirth: $dateOfBirth, email: $email, phoneNumber: $phoneNumber, address: $address, company: $company, jobTitle: $jobTitle, expertise: $expertise, education: $education, joinedDate: $joinedDate, currentClubRole: $currentClubRole, previousRoles: $previousRoles)';
  }

  @override
  bool operator ==(covariant ClubMemberModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.clubId == clubId &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.gender == gender &&
        other.profession == profession &&
        other.imageUrl == imageUrl &&
        other.dateOfBirth == dateOfBirth &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.address == address &&
        other.company == company &&
        other.jobTitle == jobTitle &&
        listEquals(other.expertise, expertise) &&
        listEquals(other.education, education) &&
        other.joinedDate == joinedDate &&
        other.currentClubRole == currentClubRole &&
        listEquals(other.previousRoles, previousRoles);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        clubId.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        gender.hashCode ^
        profession.hashCode ^
        imageUrl.hashCode ^
        dateOfBirth.hashCode ^
        email.hashCode ^
        phoneNumber.hashCode ^
        address.hashCode ^
        company.hashCode ^
        jobTitle.hashCode ^
        expertise.hashCode ^
        education.hashCode ^
        joinedDate.hashCode ^
        currentClubRole.hashCode ^
        previousRoles.hashCode;
  }
}
