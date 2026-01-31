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
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Central emblem/star
          Icon(
            Icons.star,
            size: size * 0.35,
            color: const Color(0xFFD4AF37), // Gold
          ),
          // Text around the circle (simplified representation)
          Positioned(
            bottom: size * 0.15,
            child: Text(
              'MTTD',
              style: TextStyle(
                fontSize: size * 0.12,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFD4AF37),
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
