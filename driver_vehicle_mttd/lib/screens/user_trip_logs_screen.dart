import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/trip_logs_provider.dart';
import '../widgets/trip_log_card.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_message.dart';

class UserTripLogsScreen extends StatefulWidget {
  final String userId;

  const UserTripLogsScreen({super.key, required this.userId});

  @override
  State<UserTripLogsScreen> createState() => _UserTripLogsScreenState();
}

class _UserTripLogsScreenState extends State<UserTripLogsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TripLogsProvider>(context, listen: false)
          .fetchTripLogsByUserId(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Trip Logs'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<TripLogsProvider>(context, listen: false)
                  .fetchTripLogsByUserId(widget.userId);
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Consumer<TripLogsProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const LoadingIndicator(
              message: 'Loading trip logs...',
            );
          }

          if (provider.hasError) {
            return ErrorMessage(
              message: provider.errorMessage ?? 'An error occurred',
              onRetry: () {
                provider.fetchTripLogsByUserId(widget.userId);
              },
            );
          }

          if (!provider.hasLogs) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 64,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Trip Logs Found',
                      style: theme.textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This user has no recorded trip logs.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: provider.tripLogs.length,
            itemBuilder: (context, index) {
              return TripLogCard(tripLog: provider.tripLogs[index]);
            },
          );
        },
      ),
    );
  }
}
