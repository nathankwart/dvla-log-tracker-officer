import 'package:flutter/material.dart';
import '../widgets/report_summary_card.dart';
import '../widgets/report_item_card.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reports History',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Placeholder - filter functionality
                    },
                    icon: Icon(
                      Icons.filter_list,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            
            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search DV Number or status...',
                                hintStyle: TextStyle(
                                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Summary Cards
                    Row(
                      children: [
                        ReportSummaryCard(
                          title: 'TOTAL SCANS',
                          value: '128',
                          percentage: '+12%',
                          valueColor: theme.colorScheme.onSurface,
                          percentageColor: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        ReportSummaryCard(
                          title: 'VERIFIED',
                          value: '114',
                          percentage: '89%',
                          valueColor: const Color(0xFF10B981), // Green
                          percentageColor: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                        const SizedBox(width: 12),
                        ReportSummaryCard(
                          title: 'FLAGGED',
                          value: '14',
                          percentage: '11%',
                          valueColor: const Color(0xFFEF4444), // Red
                          percentageColor: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Reports List
                    // TODAY, OCT 24
                    Text(
                      'TODAY, OCT 24',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ReportItemCard(
                      dvNumber: 'DV 9021 - 24',
                      status: ReportStatus.verified,
                      time: '14:22',
                    ),
                    ReportItemCard(
                      dvNumber: 'DV 4410 - 24',
                      status: ReportStatus.flagged,
                      time: '13:05',
                    ),
                    ReportItemCard(
                      dvNumber: 'DV 1152 - 24',
                      status: ReportStatus.expired,
                      time: '11:45',
                    ),
                    const SizedBox(height: 24),
                    
                    // YESTERDAY, OCT 23
                    Text(
                      'YESTERDAY, OCT 23',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ReportItemCard(
                      dvNumber: 'DV 2289 - 24',
                      status: ReportStatus.verified,
                      time: '17:40',
                    ),
                    ReportItemCard(
                      dvNumber: 'DV 3301 - 24',
                      status: ReportStatus.verified,
                      time: '16:15',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
