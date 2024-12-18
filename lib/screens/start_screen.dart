import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[700],
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/asset/home_Screen.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Image.asset(
                'lib/asset/math_rush_logo.png',
                width: 390,
                height: 390,
                fit: BoxFit.contain,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/create');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF895CB2),
                minimumSize: const Size(300, 50),
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: const BorderSide(color: Colors.white, width: 2),
                ),
                elevation: 5,
              ),
              child: const Text(
                'Start Game',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'LazySmooth',
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 450),
          ],
        ),
      ),
    );
  }
}
