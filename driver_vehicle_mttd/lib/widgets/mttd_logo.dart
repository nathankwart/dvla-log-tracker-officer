import 'package:flutter/material.dart';

class MTTDLogo extends StatelessWidget {
  final double size;
  
  const MTTDLogo({
    super.key,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF1B4D3E), // Dark green background
        border: Border.all(
          color: const Color(0xFFD4AF37), // Gold border
          width: 3,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.security,
              size: size * 0.4,
              color: const Color(0xFFD4AF37), // Gold icon
            ),
            const SizedBox(height: 4),
            Text(
              'MTTD',
              style: TextStyle(
                fontSize: size * 0.15,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFD4AF37),
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
