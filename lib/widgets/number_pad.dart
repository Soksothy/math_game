import 'package:flutter/material.dart';

class NumberPad extends StatelessWidget {
  final void Function(int) onNumberSelected;
  final TextStyle textStyle;

  const NumberPad({
    super.key,
    required this.onNumberSelected,
    this.textStyle = const TextStyle(),
  });

  Widget _buildNumberButton(int number) {
    return SizedBox(
      width: 80,  // Increased from 50
      height: 80, // Increased from 50
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          elevation: 0,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.transparent,
        ).copyWith(
          splashFactory: NoSplash.splashFactory,
        ),
        onPressed: () => onNumberSelected(number),
        child: Image.asset(
          'lib/asset/numbers/num$number.png',
          width: 65,  // Increased from 40
          height: 65, // Increased from 40
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            print('Error loading image: $error');
            return Text(
              number.toString(),
              style: textStyle,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8.0), // Reduced from 16.0
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [0, 1, 2, 3, 4].map((n) => _buildNumberButton(n)).toList(),
            ),
            const SizedBox(height: 12), // Reduced from 16
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [5, 6, 7, 8, 9].map((n) => _buildNumberButton(n)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}