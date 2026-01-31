class AppConstants {
  // Firestore Collections
  static const String vehiclesCollection = 'vehicles';
  static const String tripLogsCollection = 'tripLogs';
  static const String officersCollection = 'officers';

  // Shared Preferences Keys
  static const String authStateKey = 'auth_state';
  static const String userIdKey = 'user_id';

  // QR Code Format
  static const String qrCodePrefix = 'VEHICLE:';
  
  // Error Messages
  static const String noLogsMessage = 'No trip logs found for this vehicle.';
  static const String invalidVehicleMessage = 'Invalid vehicle identifier.';
  static const String networkErrorMessage = 'Network error. Please check your connection.';
  static const String scanningErrorMessage = 'Error scanning QR code. Please try again.';
}
