import 'package:flutter/material.dart';

enum VerificationStatus {
  verified,
  expired,
  pending,
}

class VerificationHistoryCard extends StatelessWidget {
  final String dvNumber;
  final String vehicleName;
  final String statusText; // e.g., "Roadworthy 2025", "Insurance lapsed"
  final VerificationStatus status;

  const VerificationHistoryCard({
    super.key,
    required this.dvNumber,
    required this.vehicleName,
    required this.statusText,
    required this.status,
  });

  Color _getStatusColor() {
    switch (status) {
      case VerificationStatus.verified:
        return const Color(0xFF10B981); // Green
      case VerificationStatus.expired:
        return const Color(0xFFEF4444); // Red
      case VerificationStatus.pending:
        return const Color(0xFFF59E0B); // Yellow/Gold
    }
  }

  String _getStatusLabel() {
    switch (status) {
      case VerificationStatus.verified:
        return 'VERIFIED';
      case VerificationStatus.expired:
        return 'EXPIRED';
      case VerificationStatus.pending:
        return 'PENDING';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937), // Dark gray card background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
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
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$vehicleName • $statusText',
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
              color: statusColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _getStatusLabel(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 8),
          
          // Three-dot menu
          IconButton(
            onPressed: () {
              // Placeholder - menu options
            },
            icon: const Icon(
              Icons.more_vert,
              color: Color(0xFF9CA3AF),
              size: 20,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
