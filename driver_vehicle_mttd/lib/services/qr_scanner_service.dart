import '../core/constants/app_constants.dart';

class QRScannerService {
  // Extract vehicle ID from QR code
  String? extractVehicleId(String qrCodeData) {
    try {
      // Check if QR code has expected format
      if (qrCodeData.startsWith(AppConstants.qrCodePrefix)) {
        return qrCodeData.replaceFirst(AppConstants.qrCodePrefix, '');
      }
      
      // If QR code is just the vehicle ID itself
      if (qrCodeData.isNotEmpty && qrCodeData.length > 0) {
        return qrCodeData.trim();
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Validate QR code format
  bool isValidQRCode(String qrCodeData) {
    if (qrCodeData.isEmpty) return false;
    
    // Check if it starts with prefix or is a valid vehicle ID format
    if (qrCodeData.startsWith(AppConstants.qrCodePrefix)) {
      final vehicleId = qrCodeData.replaceFirst(AppConstants.qrCodePrefix, '');
      return vehicleId.isNotEmpty;
    }
    
    // Allow direct vehicle ID (alphanumeric, reasonable length)
    return qrCodeData.trim().isNotEmpty && qrCodeData.length <= 100;
  }
}
