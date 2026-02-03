class UserProfile {
  final String userId;
  final String driverName;
  final String registrationNumber;
  final String vehicleMake;
  final String vehicleModel;
  final String vehicleColor;
  final int totalTrips;

  UserProfile({
    required this.userId,
    required this.driverName,
    required this.registrationNumber,
    required this.vehicleMake,
    required this.vehicleModel,
    required this.vehicleColor,
    required this.totalTrips,
  });

  String get vehicleDescription => '$vehicleMake $vehicleModel ($vehicleColor)';
  String get fullVehicleInfo => '$registrationNumber - $vehicleDescription';
}
