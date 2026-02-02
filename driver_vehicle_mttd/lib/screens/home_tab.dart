import 'package:driver_vehicle_mttd/widgets/custom_header.dart';
import 'package:driver_vehicle_mttd/widgets/manual_entry_field.dart';
import 'package:driver_vehicle_mttd/widgets/scan_qr_code_button.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Verify Vehicle',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Scan QR code or enter DV number to verify records.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 22),
                  ScanQrCodeButton(),
                  const SizedBox(height: 22),
                  ManualEntryField(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
