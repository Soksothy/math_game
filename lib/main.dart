import 'package:flutter/material.dart';
import 'package:math_game/screens/home_screen.dart';
import 'package:math_game/screens/game_screen.dart';
import 'package:math_game/screens/start_screen.dart';
import 'package:math_game/screens/create_profile.dart';
import 'package:math_game/screens/create_profile_age.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Math Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'LazySmooth',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const StartScreen(),
        '/create': (context) => const CreateProfileScreen(),
        '/createAge': (context) => const CreateAgeScreen(),
        '/home': (context) => const HomeScreen(),
        '/game': (context) => const GameScreen(),
      },
    );
  }
}
