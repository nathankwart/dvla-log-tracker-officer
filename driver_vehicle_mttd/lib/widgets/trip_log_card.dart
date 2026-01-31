import 'package:flutter/material.dart';
import '../models/trip_log.dart';
import '../core/utils/date_formatter.dart';

class TripLogCard extends StatelessWidget {
  final TripLog tripLog;

  const TripLogCard({super.key, required this.tripLog});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormatter.formatDate(tripLog.date),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    tripLog.timeOfReturn != null ? 'Completed' : 'In Progress',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            
            // Trip Details
            _buildDetailRow(
              context,
              'Driver',
              tripLog.driverName,
              Icons.person,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              context,
              'Vehicle',
              '${tripLog.registrationNumber} - ${tripLog.vehicleDescription}',
              Icons.directions_car,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              context,
              'Reason',
              tripLog.reasonForJourney,
              Icons.description,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              context,
              'Route',
              tripLog.routeTaken,
              Icons.route,
            ),
            const SizedBox(height: 12),
            
            // Time Information
            Row(
              children: [
                Expanded(
                  child: _buildTimeInfo(
                    context,
                    'Leaving',
                    DateFormatter.formatTime(tripLog.timeOfLeaving),
                    Icons.arrow_upward,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTimeInfo(
                    context,
                    'Return',
                    tripLog.timeOfReturn != null
                        ? DateFormatter.formatTime(tripLog.timeOfReturn!)
                        : 'Not returned',
                    Icons.arrow_downward,
                    tripLog.timeOfReturn != null ? Colors.blue : Colors.grey,
                  ),
                ),
              ],
            ),
            
            // Signature if available
            if (tripLog.signatureOfPersonMakingEntry != null) ...[
              const SizedBox(height: 12),
              const Divider(),
              _buildDetailRow(
                context,
                'Entry Signature',
                tripLog.signatureOfPersonMakingEntry!,
                Icons.edit,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeInfo(
    BuildContext context,
    String label,
    String time,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }
}
