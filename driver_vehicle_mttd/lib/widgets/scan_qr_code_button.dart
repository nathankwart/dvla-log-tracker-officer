import 'package:flutter/material.dart';

class ScanQrCodeButton extends StatefulWidget {
  const ScanQrCodeButton({super.key});

  @override
  State<ScanQrCodeButton> createState() => _ScanQrCodeButtonState();
}

class _ScanQrCodeButtonState extends State<ScanQrCodeButton> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 40),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Column(
            children: [
              Icon(Icons.qr_code_scanner, color: Colors.white, size: 64),
              SizedBox(height: 12),
              Text(
                'SCAN QR CODE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
