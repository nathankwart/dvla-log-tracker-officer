import 'package:flutter/foundation.dart';
import '../models/trip_log.dart';
import '../models/vehicle.dart';
import '../models/user_profile.dart';
import '../services/firestore_service.dart';

class TripLogsProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  
  Vehicle? _vehicle;
  List<TripLog> _tripLogs = [];
  UserProfile? _userProfile;
  bool _isLoading = false;
  String? _errorMessage;

  Vehicle? get vehicle => _vehicle;
  List<TripLog> get tripLogs => _tripLogs;
  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasLogs => _tripLogs.isNotEmpty;
  bool get hasError => _errorMessage != null;

  Future<void> fetchTripLogsByVehicleId(String vehicleId) async {
    _isLoading = true;
    _errorMessage = null;
    _tripLogs = [];
    _vehicle = null;
    notifyListeners();

    try {
      // Fetch vehicle information
      _vehicle = await _firestoreService.getVehicleById(vehicleId);
      
      if (_vehicle == null) {
        _errorMessage = 'Vehicle not found. Invalid vehicle identifier.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Fetch trip logs
      _tripLogs = await _firestoreService.getTripLogsByVehicleId(vehicleId);
      
      if (_tripLogs.isEmpty) {
        _errorMessage = 'No trip logs found for this vehicle.';
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error fetching trip logs: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> fetchTripLogsByUserId(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    _tripLogs = [];
    _userProfile = null;
    _vehicle = null;
    notifyListeners();

    try {
      // Fetch trip logs for the user
      _tripLogs = await _firestoreService.getTripLogsByUserId(userId);
      
      if (_tripLogs.isEmpty) {
        _errorMessage = 'No trip logs found for this user.';
      } else {
        // Calculate user profile from trip logs
        _userProfile = _calculateUserProfile(userId, _tripLogs);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error fetching trip logs: ${e.toString()}';
      notifyListeners();
    }
  }

  // Calculate user profile from trip logs (aggregate most common values)
  UserProfile _calculateUserProfile(String userId, List<TripLog> tripLogs) {
    if (tripLogs.isEmpty) {
      return UserProfile(
        userId: userId,
        driverName: '',
        registrationNumber: '',
        vehicleMake: '',
        vehicleModel: '',
        vehicleColor: '',
        totalTrips: 0,
      );
    }

    // Get most common driver name
    final driverNameCounts = <String, int>{};
    for (var log in tripLogs) {
      driverNameCounts[log.driverName] = (driverNameCounts[log.driverName] ?? 0) + 1;
    }
    final driverName = driverNameCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    // Get most common vehicle details (use first trip log's vehicle as representative)
    final firstLog = tripLogs.first;
    final registrationNumber = firstLog.registrationNumber;
    final vehicleMake = firstLog.vehicleMake;
    final vehicleModel = firstLog.vehicleModel;
    final vehicleColor = firstLog.vehicleColor;

    return UserProfile(
      userId: userId,
      driverName: driverName,
      registrationNumber: registrationNumber,
      vehicleMake: vehicleMake,
      vehicleModel: vehicleModel,
      vehicleColor: vehicleColor,
      totalTrips: tripLogs.length,
    );
  }

  void clearData() {
    _vehicle = null;
    _tripLogs = [];
    _userProfile = null;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
