class QRScannerService {
  // Extract user ID from QR code
  // QR code payload should be a Firestore user ID (e.g., "qgkI4wEFbITCCuJvrZyqQ8hYl4A2")
  String? extractUserId(String qrCodeData) {
    try {
      // Trim whitespace
      final trimmed = qrCodeData.trim();
      
      // Check if QR code is empty
      if (trimmed.isEmpty) {
        return null;
      }
      
      // Firestore user IDs are typically 28 characters (alphanumeric)
      // But we'll accept any reasonable length alphanumeric string
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

  // Validate QR code format (should be a valid Firestore user ID)
  bool isValidQRCode(String qrCodeData) {
    if (qrCodeData.isEmpty) return false;
    
    final userId = extractUserId(qrCodeData);
    return userId != null;
  }
}
