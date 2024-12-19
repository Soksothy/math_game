import 'package:flutter/material.dart';

class AnswerOptions extends StatelessWidget {
  final List<int> options;
  final ValueChanged<int> onOptionSelected;
  final bool isEnabled;
  final double optionSize; // Add optionSize parameter
  final int rows; // Add rows parameter

  const AnswerOptions({
    super.key,
    required this.options,
    required this.onOptionSelected,
    this.isEnabled = true,
    this.optionSize = 100, // Increase option size
    this.rows = 2, // Arrange options in two rows
  });

  // Add list of soft colors
  final List<Color> _softColors = const [
    Color(0xFFB5EAD7),  // Soft Mint
    Color(0xFFFFDAC1),  // Soft Peach
    Color(0xFFC7CEEA),  // Soft Blue
    Color(0xFFFFB7B2),  // Soft Pink
    Color(0xFFE2F0CB),  // Soft Green
    Color(0xFFFFE5D9),  // Soft Orange
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80), // Add top padding to move buttons down
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton(0),
              const SizedBox(width: 20), // Reduced spacing
              _buildButton(1),
            ],
          ),
          const SizedBox(height: 20), // Reduced spacing
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton(2),
              const SizedBox(width: 20), // Reduced spacing
              _buildButton(3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(int index) {
    if (index >= options.length) {
      return const SizedBox(width: 160); // Increased placeholder width
    }
    return SizedBox(
      width: 160, // Increased fixed width
      child: ElevatedButton(
        onPressed: isEnabled ? () => onOptionSelected(options[index]) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _softColors[index % _softColors.length],
          padding: const EdgeInsets.symmetric(
            vertical: 30, // Increased vertical padding
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          '${options[index]}',
          style: const TextStyle(
            fontSize: 32,
            color: Color(0xFF525252),
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center, // Center align the text
        ),
      ),
    );
  }
}