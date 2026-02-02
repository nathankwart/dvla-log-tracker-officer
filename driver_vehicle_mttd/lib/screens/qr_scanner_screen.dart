import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/qr_scanner_service.dart';
import '../widgets/loading_indicator.dart';
import 'user_trip_logs_screen.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  final QRScannerService _qrScannerService = QRScannerService();
  bool _isProcessing = false;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleQRCode(BarcodeCapture capture) {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? rawValue = barcodes.first.rawValue;
    if (rawValue == null || rawValue.isEmpty) return;

    setState(() {
      _isProcessing = true;
      _hasError = false;
      _errorMessage = null;
    });

    // Stop the scanner while processing
    _controller.stop();

    // Extract user ID from QR code
    final String? userId = _qrScannerService.extractUserId(rawValue);

    if (userId == null) {
      setState(() {
        _isProcessing = false;
        _hasError = true;
        _errorMessage = 'Invalid QR code format. Please scan a valid user QR code.';
      });
      // Resume scanning after a delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _hasError = false;
            _errorMessage = null;
          });
          _controller.start();
        }
      });
      return;
    }

    // Navigate to trip logs screen
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => UserTripLogsScreen(userId: userId),
        ),
      );
    }
  }

  void _handleError(MobileScannerException error) {
    if (!mounted) return;

    setState(() {
      _hasError = true;
      // Handle different error types
      if (error.errorCode == MobileScannerErrorCode.permissionDenied) {
        _errorMessage = 'Camera permission denied. Please enable camera access in settings.';
      } else {
        _errorMessage = 'Camera error occurred. Please try again.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
      ),
      body: Stack(
        children: [
          // Camera view
          MobileScanner(
            controller: _controller,
            onDetect: _handleQRCode,
            errorBuilder: (context, error, child) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _handleError(error);
              });
              return child ?? const SizedBox.shrink();
            },
          ),

          // Scanning overlay
          if (!_isProcessing && !_hasError)
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.colorScheme.primary,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.all(40),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.qr_code_scanner,
                      color: Colors.white,
                      size: 80,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Position QR code within frame',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Loading indicator
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: LoadingIndicator(
                  message: 'Processing QR code...',
                ),
              ),
            ),

          // Error message
          if (_hasError && !_isProcessing)
            Container(
              color: Colors.black54,
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Card(
                  color: theme.cardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: theme.colorScheme.error,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage ?? 'An error occurred',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _hasError = false;
                              _errorMessage = null;
                            });
                            _controller.start();
                          },
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
