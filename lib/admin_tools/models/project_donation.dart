// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProjectDonation {
  final String id;
  final double amount;
  final DateTime donationDate;
  final String? donorName;
  final String? donorEmail;
  final String? message;
  final String? transactionId;
  final String? paymentMethod;
  ProjectDonation({
    required this.id,
    required this.amount,
    required this.donationDate,
    this.donorName,
    this.donorEmail,
    this.message,
    this.transactionId,
    this.paymentMethod,
  });

  ProjectDonation copyWith({
    String? id,
    double? amount,
    DateTime? donationDate,
    String? donorName,
    String? donorEmail,
    String? message,
    String? transactionId,
    String? paymentMethod,
  }) {
    return ProjectDonation(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      donationDate: donationDate ?? this.donationDate,
      donorName: donorName ?? this.donorName,
      donorEmail: donorEmail ?? this.donorEmail,
      message: message ?? this.message,
      transactionId: transactionId ?? this.transactionId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'amount': amount,
      'donationDate': donationDate.millisecondsSinceEpoch,
      'donorName': donorName,
      'donorEmail': donorEmail,
      'message': message,
      'transactionId': transactionId,
      'paymentMethod': paymentMethod,
    };
  }

  factory ProjectDonation.fromMap(Map<String, dynamic> map) {
    return ProjectDonation(
      id: map['id'] as String,
      amount: map['amount'] as double,
      donationDate: map['donationDate'].toDate(),
      donorName: map['donorName'] != null ? map['donorName'] as String : null,
      donorEmail:
          map['donorEmail'] != null ? map['donorEmail'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
      transactionId:
          map['transactionId'] != null ? map['transactionId'] as String : null,
      paymentMethod:
          map['paymentMethod'] != null ? map['paymentMethod'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProjectDonation.fromJson(String source) =>
      ProjectDonation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DonationModel(id: $id, amount: $amount, donationDate: $donationDate, donorName: $donorName, donorEmail: $donorEmail, message: $message, transactionId: $transactionId, paymentMethod: $paymentMethod)';
  }

  @override
  bool operator ==(covariant ProjectDonation other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.amount == amount &&
        other.donationDate == donationDate &&
        other.donorName == donorName &&
        other.donorEmail == donorEmail &&
        other.message == message &&
        other.transactionId == transactionId &&
        other.paymentMethod == paymentMethod;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        amount.hashCode ^
        donationDate.hashCode ^
        donorName.hashCode ^
        donorEmail.hashCode ^
        message.hashCode ^
        transactionId.hashCode ^
        paymentMethod.hashCode;
  }
}
