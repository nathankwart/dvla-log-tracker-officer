import 'package:flutter/material.dart';

class ManualEntryField extends StatefulWidget {
  const ManualEntryField({super.key});

  @override
  State<ManualEntryField> createState() => _ManualEntryFieldState();
}

class _ManualEntryFieldState extends State<ManualEntryField> {
  final _dvNumberController = TextEditingController();
  @override
  void dispose() {
    _dvNumberController.dispose();
    super.dispose();
  }

  void _handleManualEntry() {
    print('Manual entry: ${_dvNumberController.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Manual Entry Section
        const Text(
          'Manual Entry',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'DV PLATE NUMBER',
          style: TextStyle(
            color: Color(0xFF9CA3AF),
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Builder(
          builder: (context) => Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _dvNumberController,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'DV 1234 - 24',
                    hintStyle: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 16,
                    ),
                    filled: true,
                    fillColor: const Color(0xFF1F2937),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: _handleManualEntry,
                  icon: const Icon(Icons.search, color: Colors.white, size: 24),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
