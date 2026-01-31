import 'package:cloud_firestore/cloud_firestore.dart';

class TripLog {
  final String id;
  final DateTime date;
  final String reasonForJourney;
  final DateTime timeOfLeaving;
  final DateTime? timeOfReturn;
  final String routeTaken;
  final String vehicleDescription;
  final String registrationNumber;
  final String driverName;
  final String? signatureOfPersonMakingEntry;

  TripLog({
    required this.id,
    required this.date,
    required this.reasonForJourney,
    required this.timeOfLeaving,
    this.timeOfReturn,
    required this.routeTaken,
    required this.vehicleDescription,
    required this.registrationNumber,
    required this.driverName,
    this.signatureOfPersonMakingEntry,
  });

  factory TripLog.fromFirestore(Map<String, dynamic> data, String id) {
    return TripLog(
      id: id,
      date: (data['date'] as Timestamp).toDate(),
      reasonForJourney: data['reasonForJourney'] ?? '',
      timeOfLeaving: (data['timeOfLeaving'] as Timestamp).toDate(),
      timeOfReturn: data['timeOfReturn'] != null
          ? (data['timeOfReturn'] as Timestamp).toDate()
          : null,
      routeTaken: data['routeTaken'] ?? '',
      vehicleDescription: data['vehicleDescription'] ?? '',
      registrationNumber: data['registrationNumber'] ?? '',
      driverName: data['driverName'] ?? '',
      signatureOfPersonMakingEntry: data['signatureOfPersonMakingEntry'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'reasonForJourney': reasonForJourney,
      'timeOfLeaving': timeOfLeaving,
      'timeOfReturn': timeOfReturn,
      'routeTaken': routeTaken,
      'vehicleDescription': vehicleDescription,
      'registrationNumber': registrationNumber,
      'driverName': driverName,
      'signatureOfPersonMakingEntry': signatureOfPersonMakingEntry,
    };
  }
}
