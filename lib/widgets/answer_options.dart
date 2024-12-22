import 'package:flutter/material.dart';

class AnswerOptions extends StatelessWidget {
  final List<int> options;
  final ValueChanged<int> onOptionSelected;
  final bool isEnabled;
  final double optionSize;
  final int rows;

  const AnswerOptions({
    super.key,
    required this.options,
    required this.onOptionSelected,
    this.isEnabled = true,
    this.optionSize = 100,
    this.rows = 2,
  });

  final List<Color> _softColors = const [
    Color(0xFFB5EAD7),
    Color(0xFFFFDAC1),
    Color(0xFFC7CEEA),
    Color(0xFFFFB7B2),
    Color(0xFFE2F0CB),
    Color(0xFFFFE5D9),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton(0),
              const SizedBox(width: 20),
              _buildButton(1),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton(2),
              const SizedBox(width: 20),
              _buildButton(3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(int index) {
    if (index >= options.length) {
      return const SizedBox(width: 160);
    }
    return SizedBox(
      width: 160,
      child: ElevatedButton(
        onPressed: isEnabled ? () => onOptionSelected(options[index]) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _softColors[index % _softColors.length],
          padding: const EdgeInsets.symmetric(
            vertical: 30,
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
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}