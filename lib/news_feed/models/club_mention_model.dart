// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ClubMention {
  final String id;
  final String clubId;
  final String clubName;
  final String
      handle; // Will use club name as handle since ClubModel doesn't have a handle field
  final int startIndex;
  final int endIndex;

  const ClubMention({
    required this.id,
    required this.clubId,
    required this.clubName,
    required this.handle,
    required this.startIndex,
    required this.endIndex,
  });

  ClubMention copyWith({
    String? id,
    String? clubId,
    String? clubName,
    String? handle,
    int? startIndex,
    int? endIndex,
  }) {
    return ClubMention(
      id: id ?? this.id,
      clubId: clubId ?? this.clubId,
      clubName: clubName ?? this.clubName,
      handle: handle ?? this.handle,
      startIndex: startIndex ?? this.startIndex,
      endIndex: endIndex ?? this.endIndex,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'clubId': clubId,
      'clubName': clubName,
      'handle': handle,
      'startIndex': startIndex,
      'endIndex': endIndex,
    };
  }

  factory ClubMention.fromMap(Map<String, dynamic> map) {
    return ClubMention(
      id: map['id'] as String,
      clubId: map['clubId'] as String,
      clubName: map['clubName'] as String,
      handle: map['handle'] as String,
      startIndex: map['startIndex'] as int,
      endIndex: map['endIndex'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ClubMention.fromJson(String source) =>
      ClubMention.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ClubMention(id: $id, clubId: $clubId, clubName: $clubName, handle: $handle, startIndex: $startIndex, endIndex: $endIndex)';
  }

  @override
  bool operator ==(covariant ClubMention other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.clubId == clubId &&
        other.clubName == clubName &&
        other.handle == handle &&
        other.startIndex == startIndex &&
        other.endIndex == endIndex;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        clubId.hashCode ^
        clubName.hashCode ^
        handle.hashCode ^
        startIndex.hashCode ^
        endIndex.hashCode;
  }
}
