import 'package:flutter/material.dart';

class ReportSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String? percentage;
  final Color valueColor;
  final Color? percentageColor;

  const ReportSummaryCard({
    super.key,
    required this.title,
    required this.value,
    this.percentage,
    required this.valueColor,
    this.percentageColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: valueColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (percentage != null) ...[
              const SizedBox(height: 4),
              Text(
                percentage!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: percentageColor ?? theme.colorScheme.onSurface.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
