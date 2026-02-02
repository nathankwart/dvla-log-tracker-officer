import 'package:flutter/foundation.dart';
import '../models/trip_log.dart';
import '../models/vehicle.dart';
import '../services/firestore_service.dart';

class TripLogsProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  
  Vehicle? _vehicle;
  List<TripLog> _tripLogs = [];
  bool _isLoading = false;
  String? _errorMessage;

  Vehicle? get vehicle => _vehicle;
  List<TripLog> get tripLogs => _tripLogs;
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
    _vehicle = null;
    notifyListeners();

    try {
      // Fetch trip logs for the user
      _tripLogs = await _firestoreService.getTripLogsByUserId(userId);
      
      if (_tripLogs.isEmpty) {
        _errorMessage = 'No trip logs found for this user.';
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error fetching trip logs: ${e.toString()}';
      notifyListeners();
    }
  }

  void clearData() {
    _vehicle = null;
    _tripLogs = [];
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
