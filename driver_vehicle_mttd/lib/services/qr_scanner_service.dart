import '../core/constants/app_constants.dart';

class QRScannerService {
  // Extract user ID from QR code
  // QR code payload format: "dvlog:<userId>" (e.g., "dvlog:qgkI4wEFbITCCuJvrZyqQ8hYl4A2")
  String? extractUserId(String qrCodeData) {
    try {
      // Trim whitespace
      final trimmed = qrCodeData.trim();
      
      // Check if QR code is empty
      if (trimmed.isEmpty) {
        return null;
      }
      
      // Check if QR code has the expected format: "dvlog:<userId>"
      if (trimmed.startsWith(AppConstants.qrCodeUserPrefix)) {
        final userId = trimmed.replaceFirst(AppConstants.qrCodeUserPrefix, '').trim();
        
        // Validate userId format (alphanumeric, reasonable length)
        if (userId.isNotEmpty && 
            userId.length >= 20 && 
            userId.length <= 50 &&
            RegExp(r'^[a-zA-Z0-9]+$').hasMatch(userId)) {
          return userId;
        }
      }
      
      // Fallback: Check if QR code is just the userId itself (for backward compatibility)
      if (trimmed.length >= 20 && trimmed.length <= 50) {
        // Validate it's alphanumeric (Firestore IDs are alphanumeric)
        if (RegExp(r'^[a-zA-Z0-9]+$').hasMatch(trimmed)) {
          return trimmed;
        }
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Validate QR code format (should be "dvlog:<userId>" or just userId)
  bool isValidQRCode(String qrCodeData) {
    if (qrCodeData.isEmpty) return false;
    
    final userId = extractUserId(qrCodeData);
    return userId != null;
  }
}
