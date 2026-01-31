import 'package:cloud_firestore/cloud_firestore.dart';

class Officer {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String stationNumber;
  final String? displayName;
  final String? badgeNumber;
  final DateTime? createdAt;

  Officer({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.stationNumber,
    this.displayName,
    this.badgeNumber,
    this.createdAt,
  });

  String get fullName => '$firstName $lastName';

  factory Officer.fromFirestore(Map<String, dynamic> data, String id) {
    return Officer(
      id: id,
      email: data['email'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      stationNumber: data['stationNumber'] ?? '',
      displayName: data['displayName'],
      badgeNumber: data['badgeNumber'],
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'stationNumber': stationNumber,
      'displayName': displayName ?? fullName,
      'badgeNumber': badgeNumber,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}
