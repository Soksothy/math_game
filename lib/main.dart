import 'package:flutter/material.dart';
import 'package:math_game/screens/home_screen.dart';
import 'package:math_game/screens/game_screen.dart';
import 'package:math_game/screens/start_screen.dart';
import 'package:math_game/screens/create_profile.dart';
import 'package:math_game/screens/create_profile_age.dart';
import 'package:math_game/screens/results_screen.dart';
import 'package:math_game/screens/shop_screen.dart';
import 'package:math_game/screens/profile_screen.dart';
import 'package:math_game/screens/leaderboard_screen.dart';
import 'package:math_game/screens/settings_screen.dart';

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
      // Define static routes first
      routes: {
        '/': (context) => const StartScreen(),
        '/create': (context) => const CreateProfileScreen(),
        '/createAge': (context) => const CreateAgeScreen(),
      },
      // Handle dynamic routes with arguments
      onGenerateRoute: (settings) {
        final args = settings.arguments as Map<String, dynamic>?;

        switch (settings.name) {
          case '/home':
            return MaterialPageRoute(
              builder: (context) => const HomeScreen(),
              settings: settings,
            );
          case '/shop':
            if (args != null) {
              return MaterialPageRoute(
                builder: (context) => ShopScreen(user: args['userModel']),
                settings: settings,
              );
            }
            break;
          case '/profile':
            if (args != null) {
              return MaterialPageRoute(
                builder: (context) => ProfileScreen(user: args['userModel']),
                settings: settings,
              );
            }
            break;
          case '/leaderboard':
            if (args != null) {
              return MaterialPageRoute(
                builder: (context) => LeaderboardScreen(user: args['userModel']),
                settings: settings,
              );
            }
            break;
          case '/settings':
            if (args != null) {
              return MaterialPageRoute(
                builder: (context) => SettingsScreen(user: args['userModel']),
                settings: settings,
              );
            }
            break;
          case '/game':
            if (args != null) {
              return MaterialPageRoute(
                builder: (context) => const GameScreen(),
                settings: settings,
              );
            }
            break;
          case '/results':
            if (args != null) {
              return MaterialPageRoute(
                builder: (context) => const ResultsScreen(),
                settings: settings,
              );
            }
            break;
        }
        return null;
      },
      // Fallback route
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const StartScreen(),
        );
      },
    );
  }
}
