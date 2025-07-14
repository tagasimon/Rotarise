// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Model class representing a notification
class NotificationModel {
  final String id;
  final String userId; // Target user who should receive the notification
  final String title;
  final String message;
  final NotificationType type;
  final NotificationStatus status;

  /// Optional data for different notification types
  final String? actionUserId; // User who performed the action
  final String? actionUserName; // Name of user who performed the action
  final String? clubId; // Related club ID
  final String? eventId; // Related event ID
  final String? memberId; // Related member ID
  final String? imageUrl; // Optional image for the notification

  /// Metadata
  final DateTime createdAt;
  final DateTime? readAt;
  final DateTime? updatedAt;

  /// Navigation data
  final String? routeName; // Screen to navigate to when tapped
  final Map<String, dynamic>? routeParams; // Parameters for navigation

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.status,
    required this.createdAt,
    this.actionUserId,
    this.actionUserName,
    this.clubId,
    this.eventId,
    this.memberId,
    this.imageUrl,
    this.readAt,
    this.updatedAt,
    this.routeName,
    this.routeParams,
  });

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? message,
    NotificationType? type,
    NotificationStatus? status,
    String? actionUserId,
    String? actionUserName,
    String? clubId,
    String? eventId,
    String? memberId,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? readAt,
    DateTime? updatedAt,
    String? routeName,
    Map<String, dynamic>? routeParams,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      status: status ?? this.status,
      actionUserId: actionUserId ?? this.actionUserId,
      actionUserName: actionUserName ?? this.actionUserName,
      clubId: clubId ?? this.clubId,
      eventId: eventId ?? this.eventId,
      memberId: memberId ?? this.memberId,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
      updatedAt: updatedAt ?? this.updatedAt,
      routeName: routeName ?? this.routeName,
      routeParams: routeParams ?? this.routeParams,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'title': title,
      'message': message,
      'type': type.name,
      'status': status.name,
      'actionUserId': actionUserId,
      'actionUserName': actionUserName,
      'clubId': clubId,
      'eventId': eventId,
      'memberId': memberId,
      'imageUrl': imageUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'readAt': readAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'routeName': routeName,
      'routeParams': routeParams,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      title: map['title'] as String,
      message: map['message'] as String,
      type: NotificationType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => NotificationType.general,
      ),
      status: NotificationStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => NotificationStatus.unread,
      ),
      actionUserId:
          map['actionUserId'] != null ? map['actionUserId'] as String : null,
      actionUserName: map['actionUserName'] != null
          ? map['actionUserName'] as String
          : null,
      clubId: map['clubId'] != null ? map['clubId'] as String : null,
      eventId: map['eventId'] != null ? map['eventId'] as String : null,
      memberId: map['memberId'] != null ? map['memberId'] as String : null,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      readAt: map['readAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['readAt'] as int)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int)
          : null,
      routeName: map['routeName'] != null ? map['routeName'] as String : null,
      routeParams: map['routeParams'] != null
          ? Map<String, dynamic>.from(map['routeParams'] as Map)
          : null,
    );
  }

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    return NotificationModel.fromMap(data);
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NotificationModel(id: $id, userId: $userId, title: $title, message: $message, type: $type, status: $status, actionUserId: $actionUserId, actionUserName: $actionUserName, clubId: $clubId, eventId: $eventId, memberId: $memberId, imageUrl: $imageUrl, createdAt: $createdAt, readAt: $readAt, updatedAt: $updatedAt, routeName: $routeName, routeParams: $routeParams)';
  }

  @override
  bool operator ==(covariant NotificationModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.title == title &&
        other.message == message &&
        other.type == type &&
        other.status == status &&
        other.actionUserId == actionUserId &&
        other.actionUserName == actionUserName &&
        other.clubId == clubId &&
        other.eventId == eventId &&
        other.memberId == memberId &&
        other.imageUrl == imageUrl &&
        other.createdAt == createdAt &&
        other.readAt == readAt &&
        other.updatedAt == updatedAt &&
        other.routeName == routeName &&
        other.routeParams == routeParams;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        title.hashCode ^
        message.hashCode ^
        type.hashCode ^
        status.hashCode ^
        actionUserId.hashCode ^
        actionUserName.hashCode ^
        clubId.hashCode ^
        eventId.hashCode ^
        memberId.hashCode ^
        imageUrl.hashCode ^
        createdAt.hashCode ^
        readAt.hashCode ^
        updatedAt.hashCode ^
        routeName.hashCode ^
        routeParams.hashCode;
  }
}

/// Enum for different types of notifications
enum NotificationType {
  general,
  clubInvitation,
  eventInvitation,
  eventReminder,
  eventUpdate,
  membershipApproval,
  membershipRejection,
  roleAssignment,
  roleRemoval,
  newMember,
  memberLeft,
  eventCreated,
  eventCancelled,
  visitApproval,
  visitRejection,
  announcement,
  warning,
  achievement,
}

/// Enum for notification status
enum NotificationStatus {
  unread,
  read,
  archived,
  deleted,
}
