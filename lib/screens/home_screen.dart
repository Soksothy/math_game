import 'package:flutter/material.dart';
import 'package:math_game/widgets/app_bar.dart';
import 'package:math_game/widgets/bottom_navigation_bar.dart';
import 'package:math_game/models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final user = args['userModel'] as UserModel;

    return Scaffold(
      appBar: GameAppBar(
        user: user,
        stars: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          child: SingleChildScrollView( // Added SingleChildScrollView
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  width: double.infinity,
                  child: const Text(
                    'Addition',
                    style: TextStyle(fontSize: 35, color: Color(0xFF525252)),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  width: MediaQuery.of(context).size.width - 32, // Account for parent padding
                  decoration: BoxDecoration(
                      color: const Color(0xFFFFF6E3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context, 
                              '/game',  // Changed back from '/add-it-up' to '/game'
                              arguments: {
                                'userModel': user,
                                'gameType': 'addition',
                                'gameName': 'Add It Up'
                              }
                            );
                          },
                          child: Container(
                            width: 120,
                            height: 120,
                            margin: const EdgeInsets.only(left: 8, right: 8),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 184, 254, 158),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('lib/asset/add1.png', width: 80, height: 80),
                                const SizedBox(height: 8),
                                const Text('Add It Up'),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context, 
                              '/game',
                              arguments: {
                                'userModel': user,
                                'gameType': 'addition',
                                'gameName': 'Sum Sprint'
                              }
                            );
                          },
                          child: Container(
                            width: 120,
                            height: 120,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 158, 203, 254),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('lib/asset/add2.png', width: 80, height: 80), // Increased size
                                const SizedBox(height: 8),
                                const Text('Sum Sprint'),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context, 
                              '/game',
                              arguments: {
                                'userModel': user,
                                'gameType': 'addition',
                                'gameName': 'Plus Grid'
                              }
                            );
                          },
                          child: Container(
                            width: 120,
                            height: 120,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                             color: const Color.fromARGB(255, 254, 158, 158),
                            borderRadius  : BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('lib/asset/add3.png', width: 80, height: 80), // Increased size
                              const SizedBox(height: 8),
                              const Text('Plus Grid'),
                            ],
                          ),
                        ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context, 
                              '/game',
                              arguments: {
                                'userModel': user,
                                'gameType': 'addition',
                                'gameName': 'Judgement'
                              }
                            );
                          },
                          child: Container(
                            width: 120,
                            height: 120,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 190,  158, 254),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('lib/asset/add4.png', width: 80, height: 80), // Increased size
                              const SizedBox(height: 8),
                              const Text('Judgement'),
                            ],
                          ),
                        ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  width: double.infinity,
                  child: const Text(
                    'Subtraction',
                    style: TextStyle(fontSize: 35, color: Color(0xFF525252)),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  width: MediaQuery.of(context).size.width - 32, // Account for parent padding
                  decoration: BoxDecoration(
                      color: const Color(0xFFFFF6E3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context, 
                              '/game',
                              arguments: {
                                'userModel': user,
                                'gameType': 'subtraction',
                                'gameName': 'Subtract It'
                              }
                            );
                          },
                          child: Container(
                            width: 120,
                            height: 120,
                            margin: const EdgeInsets.only(left: 8, right: 8),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 174, 254, 158),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('lib/asset/sub1.png', width: 80, height: 80), // Increased size
                                const SizedBox(height: 8),
                                const Text('Subtract It'),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context, 
                              '/game',
                              arguments: {
                                'userModel': user,
                                'gameType': 'subtraction',
                                'gameName': 'Minus Mastery'
                              }
                            );
                          },
                          child: Container(
                            width: 120,
                            height: 120,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 161, 158, 254),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('lib/asset/sub2.png', width: 80, height: 80), // Increased size
                                const SizedBox(height: 8),
                                const Text('Minus Mastery'),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context, 
                              '/game',
                              arguments: {
                                'userModel': user,
                                'gameType': 'subtraction',
                                'gameName': 'Minus Grid'
                              }
                            );
                          },
                          child: Container(
                            width: 120,
                            height: 120,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                             color: const Color.fromARGB(255, 158, 200, 254),
                            borderRadius  : BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('lib/asset/sub3.png', width: 80, height: 80), // Increased size
                              const SizedBox(height: 8),
                              const Text('Minus Grid'),
                            ],
                          ),
                        ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context, 
                              '/game',
                              arguments: {
                                'userModel': user,
                                'gameType': 'subtraction',
                                'gameName': 'Judgement'
                              }
                            );
                          },
                          child: Container(
                            width: 120,
                            height: 120,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 254, 161, 158),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('lib/asset/sub4.png', width: 80, height: 80), // Increased size
                              const SizedBox(height: 8),
                              const Text('Judgement'),
                            ],
                          ),
                        ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  width: double.infinity,
                  child: const Text(
                    'Multiply',
                     style: TextStyle(fontSize: 35, color: Color(0xFF525252)),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  width: MediaQuery.of(context).size.width - 32, // Account for parent padding
                  decoration: BoxDecoration(
                      color: const Color(0xFFFFF6E3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Center the row
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context, 
                              '/game',
                              arguments: {
                                'userModel': user,
                                'gameType': 'multiplication',
                                'gameName': 'Mul Master'
                              }
                            );
                          },
                          child: Container(
                            width: 120,
                            height: 120,
                            margin: const EdgeInsets.symmetric(horizontal: 8), // Adjusted margin
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 182, 254, 158),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('lib/asset/mul1.png', width: 80, height: 80), // Increased size
                                const SizedBox(height: 8),
                                const Text('Mul Master'),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context, 
                              '/game',
                              arguments: {
                                'userModel': user,
                                'gameType': 'multiplication',
                                'gameName': 'Mul Hero'
                              }
                            );
                          },
                          child: Container(
                            width: 120,
                            height: 120,
                            margin: const EdgeInsets.symmetric(horizontal: 8), // Adjusted margin
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 158, 206, 254),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('lib/asset/mul2.png', width: 80, height: 80), // Increased size
                                const SizedBox(height: 8),
                                const Text('Mul Hero'), 
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context, 
                              '/game',
                              arguments: {
                                'userModel': user,
                                'gameType': 'multiplication',
                                'gameName': 'Perfect Mul'
                              }
                            );
                          },
                          child: Container(
                            width: 120,
                            height: 120,
                            margin: const EdgeInsets.symmetric(horizontal: 8), // Adjusted margin
                            decoration: BoxDecoration(
                             color: const Color.fromARGB(255, 158, 254, 222),
                            borderRadius  : BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('lib/asset/mul3.png', width: 80, height: 80), // Increased size
                              const SizedBox(height: 8),
                              const Text('Perfect Mul'),
                            ],
                          ),
                        ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  width: double.infinity,
                  child: const Text(
                    'Divide',
                     style: TextStyle(fontSize: 35, color: Color(0xFF525252)),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  width: MediaQuery.of(context).size.width - 32, // Account for parent padding
                  decoration: BoxDecoration(
                      color: const Color(0xFFFFF6E3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Center the row
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context, 
                              '/game',
                              arguments: {
                                'userModel': user,
                                'gameType': 'division',
                                'gameName': 'Div Hunter'
                              }
                            );
                          },
                          child: Container(
                            width: 120,
                            height: 120,
                            margin: const EdgeInsets.symmetric(horizontal: 8), // Adjusted margin
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 158, 254, 184),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('lib/asset/div1.png', width: 80, height: 80), // Increased size
                                const SizedBox(height: 8),
                                const Text('Div Hunter'),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context, 
                              '/game',
                              arguments: {
                                'userModel': user,
                                'gameType': 'division',
                                'gameName': 'Div Genius'
                              }
                            );
                          },
                          child: Container(
                            width: 120,
                            height: 120,
                            margin: const EdgeInsets.symmetric(horizontal: 8), // Adjusted margin
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 158, 211, 254),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('lib/asset/div2.png', width: 80, height: 80), // Increased size
                                const SizedBox(height: 8),
                                const Text('Div Genius'), 
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context, 
                              '/game',
                              arguments: {
                                'userModel': user,
                                'gameType': 'division',
                                'gameName': 'Side Quest'
                              }
                            );
                          },
                          child: Container(
                            width: 120,
                            height: 120,
                            margin: const EdgeInsets.symmetric(horizontal: 8), // Adjusted margin
                            decoration: BoxDecoration(
                             color: const Color.fromARGB(255, 208, 158, 254),
                            borderRadius  : BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('lib/asset/div3.png', width: 80, height: 80), // Increased size
                              const SizedBox(height: 8),
                              const Text('Side Quest'),
                            ],
                          ),
                        ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onIndexChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
