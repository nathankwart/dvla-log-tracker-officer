import 'package:flutter/material.dart';

enum ReportStatus {
  verified,
  flagged,
  expired,
}

class ReportItemCard extends StatelessWidget {
  final String dvNumber;
  final ReportStatus status;
  final String time;

  const ReportItemCard({
    super.key,
    required this.dvNumber,
    required this.status,
    required this.time,
  });

  Color _getStatusColor() {
    switch (status) {
      case ReportStatus.verified:
        return const Color(0xFF10B981); // Green
      case ReportStatus.flagged:
        return const Color(0xFFEF4444); // Red
      case ReportStatus.expired:
        return const Color(0xFFF59E0B); // Amber/Orange
    }
  }

  String _getStatusLabel() {
    switch (status) {
      case ReportStatus.verified:
        return 'VERIFIED';
      case ReportStatus.flagged:
        return 'FLAGGED';
      case ReportStatus.expired:
        return 'EXPIRED';
    }
  }

  IconData _getStatusIcon() {
    switch (status) {
      case ReportStatus.verified:
        return Icons.check_circle;
      case ReportStatus.flagged:
        return Icons.warning;
      case ReportStatus.expired:
        return Icons.schedule;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Status Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getStatusIcon(),
              color: statusColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          
          // DV Number and Status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      dvNumber,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _getStatusLabel(),
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          // Arrow Icon
          Icon(
            Icons.chevron_right,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
            size: 20,
          ),
        ],
      ),
    );
  }
}
