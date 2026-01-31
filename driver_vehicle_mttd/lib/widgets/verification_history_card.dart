import 'package:flutter/material.dart';

enum VerificationStatus {
  verified,
  expired,
}

class VerificationHistoryCard extends StatelessWidget {
  final String dvNumber;
  final String vehicleName;
  final String timestamp;
  final VerificationStatus status;

  const VerificationHistoryCard({
    super.key,
    required this.dvNumber,
    required this.vehicleName,
    required this.timestamp,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isVerified = status == VerificationStatus.verified;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937), // Dark gray card background
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Status Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isVerified
                  ? const Color(0xFF10B981) // Green
                  : const Color(0xFFF59E0B), // Amber/Orange
              shape: BoxShape.circle,
            ),
            child: Icon(
              isVerified ? Icons.check : Icons.warning_amber_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          
          // Vehicle Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dvNumber,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$vehicleName • $timestamp',
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF), // Light gray
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isVerified
                  ? const Color(0xFF10B981) // Green
                  : const Color(0xFFF59E0B), // Amber/Orange
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isVerified ? 'VERIFIED' : 'EXPIRED',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
