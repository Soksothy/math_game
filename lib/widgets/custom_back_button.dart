import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const CustomBackButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(
        icon: Image.asset(
          'lib/asset/back_icon.png',
          width: 40,
          height: 40,
        ),
        color: Colors.blue,
        onPressed: onPressed ?? () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Quit Game?'),
              content: const Text('Are you sure you want to quit? Your progress will be lost.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); 
                    Navigator.pop(context); 
                  },
                  child: const Text('Quit'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}