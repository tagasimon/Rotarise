// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ClubModel {
  final String id;
  final String name;
  final String? nickName;
  final String? description;
  final String? imageUrl;
  final String? coverImageUrl;
  final String? email;
  final String? phone;
  final String? website;
  final String? facebook;
  final String? instagram;
  final String? twitter;
  final String? linkedin;
  final String? youtube;
  final String? whatsapp;
  final String? location;
  final String? country;
  final String? city;
  final String? address;
  final String? postalCode;
  final String? meetingDay;
  final String? meetingTime;
  final Object? foundedDate;
  final Object? createdAt;
  final bool isVerified;
  // adminlist
  // editorlist
  ClubModel({
    required this.id,
    required this.name,
    this.nickName,
    this.description,
    this.imageUrl,
    this.coverImageUrl,
    this.email,
    this.phone,
    this.website,
    this.facebook,
    this.instagram,
    this.twitter,
    this.linkedin,
    this.youtube,
    this.whatsapp,
    this.location,
    this.country,
    this.city,
    this.address,
    this.postalCode,
    this.meetingDay,
    this.meetingTime,
    this.foundedDate,
    this.createdAt,
    required this.isVerified,
  });

  ClubModel copyWith({
    String? id,
    String? name,
    String? nickName,
    String? description,
    String? imageUrl,
    String? coverImageUrl,
    String? email,
    String? phone,
    String? website,
    String? facebook,
    String? instagram,
    String? twitter,
    String? linkedin,
    String? youtube,
    String? whatsapp,
    String? location,
    String? country,
    String? city,
    String? address,
    String? postalCode,
    String? meetingDay,
    String? meetingTime,
    Object? foundedDate,
    Object? createdAt,
    bool? isVerified,
  }) {
    return ClubModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nickName: nickName ?? this.nickName,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      facebook: facebook ?? this.facebook,
      instagram: instagram ?? this.instagram,
      twitter: twitter ?? this.twitter,
      linkedin: linkedin ?? this.linkedin,
      youtube: youtube ?? this.youtube,
      whatsapp: whatsapp ?? this.whatsapp,
      location: location ?? this.location,
      country: country ?? this.country,
      city: city ?? this.city,
      address: address ?? this.address,
      postalCode: postalCode ?? this.postalCode,
      meetingDay: meetingDay ?? this.meetingDay,
      meetingTime: meetingTime ?? this.meetingTime,
      foundedDate: foundedDate ?? this.foundedDate,
      createdAt: createdAt ?? this.createdAt,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'nickName': nickName,
      'description': description,
      'imageUrl': imageUrl,
      'coverImageUrl': coverImageUrl,
      'email': email,
      'phone': phone,
      'website': website,
      'facebook': facebook,
      'instagram': instagram,
      'twitter': twitter,
      'linkedin': linkedin,
      'youtube': youtube,
      'whatsapp': whatsapp,
      'location': location,
      'country': country,
      'city': city,
      'address': address,
      'postalCode': postalCode,
      'meetingDay': meetingDay,
      'meetingTime': meetingTime,
      'foundedDate': foundedDate,
      'createdAt': createdAt,
      'isVerified': isVerified,
    };
  }

  factory ClubModel.fromMap(DocumentSnapshot snapshot) {
    final map = snapshot.data() as Map<String, dynamic>;
    return ClubModel(
      id: map['id'] as String,
      name: map['name'] as String,
      nickName: map['nickName'] != null ? map['nickName'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      coverImageUrl:
          map['coverImageUrl'] != null ? map['coverImageUrl'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      website: map['website'] != null ? map['website'] as String : null,
      facebook: map['facebook'] != null ? map['facebook'] as String : null,
      instagram: map['instagram'] != null ? map['instagram'] as String : null,
      twitter: map['twitter'] != null ? map['twitter'] as String : null,
      linkedin: map['linkedin'] != null ? map['linkedin'] as String : null,
      youtube: map['youtube'] != null ? map['youtube'] as String : null,
      whatsapp: map['whatsapp'] != null ? map['whatsapp'] as String : null,
      location: map['location'] != null ? map['location'] as String : null,
      country: map['country'] != null ? map['country'] as String : null,
      city: map['city'] != null ? map['city'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      postalCode:
          map['postalCode'] != null ? map['postalCode'] as String : null,
      meetingDay:
          map['meetingDay'] != null ? map['meetingDay'] as String : null,
      meetingTime:
          map['meetingTime'] != null ? map['meetingTime'] as String : null,
      foundedDate: map['foundedDate']?.toDate(),
      createdAt: map['createdAt']?.toDate(),
      isVerified: map['isVerified'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ClubModel.fromJson(String source) =>
      ClubModel.fromMap(json.decode(source) as DocumentSnapshot);

  @override
  String toString() {
    return 'ClubModel(id: $id, name: $name, nickName: $nickName, description: $description, imageUrl: $imageUrl, coverImageUrl: $coverImageUrl, email: $email, phone: $phone, website: $website, facebook: $facebook, instagram: $instagram, twitter: $twitter, linkedin: $linkedin, youtube: $youtube, whatsapp: $whatsapp, location: $location, country: $country, city: $city, address: $address, postalCode: $postalCode, meetingDay: $meetingDay, meetingTime: $meetingTime, foundedDate: $foundedDate, createdAt: $createdAt, isVerified: $isVerified)';
  }

  @override
  bool operator ==(covariant ClubModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.nickName == nickName &&
        other.description == description &&
        other.imageUrl == imageUrl &&
        other.coverImageUrl == coverImageUrl &&
        other.email == email &&
        other.phone == phone &&
        other.website == website &&
        other.facebook == facebook &&
        other.instagram == instagram &&
        other.twitter == twitter &&
        other.linkedin == linkedin &&
        other.youtube == youtube &&
        other.whatsapp == whatsapp &&
        other.location == location &&
        other.country == country &&
        other.city == city &&
        other.address == address &&
        other.postalCode == postalCode &&
        other.meetingDay == meetingDay &&
        other.meetingTime == meetingTime &&
        other.foundedDate == foundedDate &&
        other.createdAt == createdAt &&
        other.isVerified == isVerified;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        nickName.hashCode ^
        description.hashCode ^
        imageUrl.hashCode ^
        coverImageUrl.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        website.hashCode ^
        facebook.hashCode ^
        instagram.hashCode ^
        twitter.hashCode ^
        linkedin.hashCode ^
        youtube.hashCode ^
        whatsapp.hashCode ^
        location.hashCode ^
        country.hashCode ^
        city.hashCode ^
        address.hashCode ^
        postalCode.hashCode ^
        meetingDay.hashCode ^
        meetingTime.hashCode ^
        foundedDate.hashCode ^
        createdAt.hashCode ^
        isVerified.hashCode;
  }
}
