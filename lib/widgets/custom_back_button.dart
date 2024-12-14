import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final double width;
  final double height;
  final String? routeName;

  const CustomBackButton({
    Key? key,
    this.width = 200,
    this.height = 200,
    this.routeName = '/',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Image.asset(
        'lib/asset/back_icon.png',
        width: width,
        height: height,
      ),
      onPressed: () {
        Navigator.of(context).pushReplacementNamed(routeName!);
      },
    );
  }
}