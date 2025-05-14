// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SponsorModel {
  final String id;
  final String name;
  final String industry;
  final String? logoUrl;
  final String? websiteUrl;
  final String? description;
  SponsorModel({
    required this.id,
    required this.name,
    required this.industry,
    this.logoUrl,
    this.websiteUrl,
    this.description,
  });

  SponsorModel copyWith({
    String? id,
    String? name,
    String? industry,
    String? logoUrl,
    String? websiteUrl,
    String? description,
  }) {
    return SponsorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      industry: industry ?? this.industry,
      logoUrl: logoUrl ?? this.logoUrl,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'industry': industry,
      'logoUrl': logoUrl,
      'websiteUrl': websiteUrl,
      'description': description,
    };
  }

  factory SponsorModel.fromMap(Map<String, dynamic> map) {
    return SponsorModel(
      id: map['id'] as String,
      name: map['name'] as String,
      industry: map['industry'] as String,
      logoUrl: map['logoUrl'] != null ? map['logoUrl'] as String : null,
      websiteUrl:
          map['websiteUrl'] != null ? map['websiteUrl'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SponsorModel.fromJson(String source) =>
      SponsorModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SponsorModel(id: $id, name: $name, industry: $industry, logoUrl: $logoUrl, websiteUrl: $websiteUrl, description: $description)';
  }

  @override
  bool operator ==(covariant SponsorModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.industry == industry &&
        other.logoUrl == logoUrl &&
        other.websiteUrl == websiteUrl &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        industry.hashCode ^
        logoUrl.hashCode ^
        websiteUrl.hashCode ^
        description.hashCode;
  }
}
