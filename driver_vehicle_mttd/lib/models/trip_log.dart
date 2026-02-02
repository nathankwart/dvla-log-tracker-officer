import 'package:cloud_firestore/cloud_firestore.dart';

class LocationData {
  final String address;
  final double latitude;
  final double longitude;

  LocationData({
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory LocationData.fromMap(Map<String, dynamic> map) {
    return LocationData(
      address: map['address'] ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class TripLog {
  final String id;
  final String userId;
  final DateTime createdAt;
  final DateTime date;
  final String status;
  final String driverName;
  final String registrationNumber;
  final String vehicleMake;
  final String vehicleModel;
  final String vehicleColor;
  final String reasonForJourney;
  final String routeTaken;
  final String timeLeaving;
  final String timeReturn;
  final String qrCodeData;
  final LocationData? startLocation;
  final LocationData? destinationLocation;
  final String? signature;

  TripLog({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.date,
    required this.status,
    required this.driverName,
    required this.registrationNumber,
    required this.vehicleMake,
    required this.vehicleModel,
    required this.vehicleColor,
    required this.reasonForJourney,
    required this.routeTaken,
    required this.timeLeaving,
    required this.timeReturn,
    required this.qrCodeData,
    this.startLocation,
    this.destinationLocation,
    this.signature,
  });

  factory TripLog.fromFirestore(Map<String, dynamic> data, String id) {
    return TripLog(
      id: id,
      userId: data['userId'] ?? '',
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      date: data['date'] != null
          ? (data['date'] is Timestamp
              ? (data['date'] as Timestamp).toDate()
              : DateTime.parse(data['date']))
          : DateTime.now(),
      status: data['status'] ?? '',
      driverName: data['driverName'] ?? '',
      registrationNumber: data['registrationNumber'] ?? '',
      vehicleMake: data['vehicleMake'] ?? '',
      vehicleModel: data['vehicleModel'] ?? '',
      vehicleColor: data['vehicleColor'] ?? '',
      reasonForJourney: data['reasonForJourney'] ?? '',
      routeTaken: data['routeTaken'] ?? '',
      timeLeaving: data['timeLeaving'] ?? '',
      timeReturn: data['timeReturn'] ?? '',
      qrCodeData: data['qrCodeData'] ?? '',
      startLocation: data['startLocation'] != null
          ? LocationData.fromMap(Map<String, dynamic>.from(data['startLocation']))
          : null,
      destinationLocation: data['destinationLocation'] != null
          ? LocationData.fromMap(Map<String, dynamic>.from(data['destinationLocation']))
          : null,
      signature: data['signature'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'createdAt': createdAt,
      'date': date,
      'status': status,
      'driverName': driverName,
      'registrationNumber': registrationNumber,
      'vehicleMake': vehicleMake,
      'vehicleModel': vehicleModel,
      'vehicleColor': vehicleColor,
      'reasonForJourney': reasonForJourney,
      'routeTaken': routeTaken,
      'timeLeaving': timeLeaving,
      'timeReturn': timeReturn,
      'qrCodeData': qrCodeData,
      'startLocation': startLocation?.toMap(),
      'destinationLocation': destinationLocation?.toMap(),
      'signature': signature,
    };
  }
}
