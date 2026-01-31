import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/trip_logs_provider.dart';
import '../widgets/trip_log_card.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_message.dart';

class TripLogsScreen extends StatefulWidget {
  final String vehicleId;

  const TripLogsScreen({super.key, required this.vehicleId});

  @override
  State<TripLogsScreen> createState() => _TripLogsScreenState();
}

class _TripLogsScreenState extends State<TripLogsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TripLogsProvider>(context, listen: false)
          .fetchTripLogsByVehicleId(widget.vehicleId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<TripLogsProvider>(context, listen: false)
                  .fetchTripLogsByVehicleId(widget.vehicleId);
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
                provider.fetchTripLogsByVehicleId(widget.vehicleId);
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
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Trip Logs Found',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This vehicle has no recorded trip logs.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              // Vehicle Information Header
              if (provider.vehicle != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vehicle Information',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Registration: ${provider.vehicle!.registrationNumber}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                      ),
                      if (provider.vehicle!.description.isNotEmpty)
                        Text(
                          'Description: ${provider.vehicle!.description}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                        ),
                    ],
                  ),
                ),

              // Trip Logs List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: provider.tripLogs.length,
                  itemBuilder: (context, index) {
                    return TripLogCard(tripLog: provider.tripLogs[index]);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
