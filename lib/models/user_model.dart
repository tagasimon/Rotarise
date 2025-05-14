// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';

// class UserModel {
//   final String id;
//   final String? name;
//   final String? email;
//   final String? phoneNumber;
//   final Object? createdAt;
//   final bool? isActive;
//   final bool? isVerified;
//   final String? photoUrl;
//   final List<String>? clubs;
//   UserModel({
//     required this.id,
//     this.name,
//     this.email,
//     this.phoneNumber,
//     this.createdAt,
//     this.isActive,
//     this.isVerified,
//     this.photoUrl,
//     this.clubs,
//   });

//   UserModel copyWith({
//     String? id,
//     String? name,
//     String? email,
//     String? phoneNumber,
//     Object? createdAt,
//     bool? isActive,
//     bool? isVerified,
//     String? photoUrl,
//     List<String>? clubs,
//   }) {
//     return UserModel(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       email: email ?? this.email,
//       phoneNumber: phoneNumber ?? this.phoneNumber,
//       createdAt: createdAt ?? this.createdAt,
//       isActive: isActive ?? this.isActive,
//       isVerified: isVerified ?? this.isVerified,
//       photoUrl: photoUrl ?? this.photoUrl,
//       clubs: clubs ?? this.clubs,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'id': id,
//       'name': name,
//       'email': email,
//       'phoneNumber': phoneNumber,
//       'createdAt': createdAt,
//       'isActive': isActive,
//       'isVerified': isVerified,
//       'photoUrl': photoUrl,
//       'clubs': clubs,
//     };
//   }

//   factory UserModel.fromMap(DocumentSnapshot snapshot) {
//     final map = snapshot.data() as Map<String, dynamic>;
//     return UserModel(
//       id: map['id'] as String,
//       name: map['name'] != null ? map['name'] as String : null,
//       email: map['email'] != null ? map['email'] as String : null,
//       phoneNumber:
//           map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
//       createdAt: map['createdAt']?.toDate(),
//       isActive: map['isActive'] != null ? map['isActive'] as bool : null,
//       isVerified: map['isVerified'] != null ? map['isVerified'] as bool : null,
//       photoUrl: map['photoUrl'] != null ? map['photoUrl'] as String : null,
//       clubs: map['clubs'] != null
//           ? List<String>.from(map['clubs'] as List<dynamic>)
//           : null,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory UserModel.fromJson(String source) =>
//       UserModel.fromMap(json.decode(source) as DocumentSnapshot);

//   @override
//   String toString() {
//     return 'UserModel(id: $id, name: $name, email: $email, phoneNumber: $phoneNumber, createdAt: $createdAt, isActive: $isActive, isVerified: $isVerified, photoUrl: $photoUrl, clubs: $clubs)';
//   }

//   @override
//   bool operator ==(covariant UserModel other) {
//     if (identical(this, other)) return true;

//     return other.id == id &&
//         other.name == name &&
//         other.email == email &&
//         other.phoneNumber == phoneNumber &&
//         other.createdAt == createdAt &&
//         other.isActive == isActive &&
//         other.isVerified == isVerified &&
//         other.photoUrl == photoUrl &&
//         listEquals(other.clubs, clubs);
//   }

//   @override
//   int get hashCode {
//     return id.hashCode ^
//         name.hashCode ^
//         email.hashCode ^
//         phoneNumber.hashCode ^
//         createdAt.hashCode ^
//         isActive.hashCode ^
//         isVerified.hashCode ^
//         photoUrl.hashCode ^
//         clubs.hashCode;
//   }
// }
