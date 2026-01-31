import 'package:cloud_firestore/cloud_firestore.dart';

class Vehicle {
  final String id;
  final String registrationNumber;
  final String description;
  final DateTime? createdAt;

  Vehicle({
    required this.id,
    required this.registrationNumber,
    required this.description,
    this.createdAt,
  });

  factory Vehicle.fromFirestore(Map<String, dynamic> data, String id) {
    return Vehicle(
      id: id,
      registrationNumber: data['registrationNumber'] ?? '',
      description: data['description'] ?? '',
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'registrationNumber': registrationNumber,
      'description': description,
      'createdAt': createdAt,
    };
  }
}
