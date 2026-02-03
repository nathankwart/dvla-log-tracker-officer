import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/trip_log.dart';
import '../models/vehicle.dart';
import '../models/officer.dart';
import '../core/constants/app_constants.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get vehicle by ID
  Future<Vehicle?> getVehicleById(String vehicleId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.vehiclesCollection)
          .doc(vehicleId)
          .get();

      if (doc.exists && doc.data() != null) {
        return Vehicle.fromFirestore(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw 'Error fetching vehicle information: ${e.toString()}';
    }
  }

  // Get all trip logs for a vehicle (chronologically ordered)
  Future<List<TripLog>> getTripLogsByVehicleId(String vehicleId) async {
    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.tripLogsCollection)
          .where('vehicleId', isEqualTo: vehicleId)
          .orderBy('date', descending: true)
          .orderBy('timeOfLeaving', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => TripLog.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw 'Error fetching trip logs: ${e.toString()}';
    }
  }

  // Get all trip logs for a user (chronologically ordered)
  Future<List<TripLog>> getTripLogsByUserId(String userId) async {
    try {
      // First try with orderBy (requires composite index)
      try {
        final querySnapshot = await _firestore
            .collection(AppConstants.tripLogsCollection)
            .where('userId', isEqualTo: userId)
            .orderBy('createdAt', descending: true)
            .get();

        return querySnapshot.docs
            .map((doc) => TripLog.fromFirestore(doc.data(), doc.id))
            .toList();
      } catch (e) {
        // If index error, fallback to fetching without orderBy and sort in memory
        final errorString = e.toString();
        if (errorString.contains('index') || errorString.contains('failed-precondition')) {
          // Fetch without orderBy
          final querySnapshot = await _firestore
              .collection(AppConstants.tripLogsCollection)
              .where('userId', isEqualTo: userId)
              .get();

          // Sort in memory by createdAt descending
          final tripLogs = querySnapshot.docs
              .map((doc) => TripLog.fromFirestore(doc.data(), doc.id))
              .toList();
          
          tripLogs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return tripLogs;
        }
        // Re-throw if it's a different error
        rethrow;
      }
    } catch (e) {
      throw 'Error fetching trip logs: ${e.toString()}';
    }
  }

  // Stream trip logs for real-time updates
  Stream<List<TripLog>> streamTripLogsByVehicleId(String vehicleId) {
    return _firestore
        .collection(AppConstants.tripLogsCollection)
        .where('vehicleId', isEqualTo: vehicleId)
        .orderBy('date', descending: true)
        .orderBy('timeOfLeaving', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TripLog.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  // Verify vehicle exists
  Future<bool> vehicleExists(String vehicleId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.vehiclesCollection)
          .doc(vehicleId)
          .get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  // Check if station number already exists
  Future<bool> stationNumberExists(String stationNumber) async {
    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.officersCollection)
          .where('stationNumber', isEqualTo: stationNumber)
          .limit(1)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Create officer profile in Firestore
  Future<void> createOfficerProfile({
    required String userId,
    required String email,
    required String firstName,
    required String lastName,
    required String stationNumber,
  }) async {
    try {
      await _firestore.collection(AppConstants.officersCollection).doc(userId).set({
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'stationNumber': stationNumber,
        'displayName': '$firstName $lastName',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Error creating officer profile: ${e.toString()}';
    }
  }

  // Get officer by user ID
  Future<Officer?> getOfficerById(String userId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.officersCollection)
          .doc(userId)
          .get();

      if (doc.exists && doc.data() != null) {
        return Officer.fromFirestore(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw 'Error fetching officer data: ${e.toString()}';
    }
  }
}
