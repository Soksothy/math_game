import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel user;

  const ProfileScreen({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GameAppBar(user: user),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 65,
                backgroundColor: const Color.fromARGB(255, 245, 185, 95),
                child: const CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('lib/asset/sothy.png'),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // User Info
            Text(
              'Sok Sothy',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Software Engineering Student at CADT',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF7B7B7B),
              ),
            ),
            const SizedBox(height: 8),
            const Chip(
              label: Text(
                'Year 3',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              backgroundColor: Colors.orange,
            ),
            const SizedBox(height: 16),

            // Section Divider
            const Divider(
              color: Colors.grey,
              thickness: 0.5,
            ),
            const SizedBox(height: 16),

            // Description
            const Text(
                'Math Rush is my Final Flutter project.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF7B7B7B),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Instructor: Ronan Ogor',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF7B7B7B),
              ),
            ),
            const SizedBox(height: 24),

            // Review Section
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(Icons.star, color: Colors.orange, size: 40),
                  const SizedBox(height: 8),
                  const Text(
                    'As the developer of this app, my hope is to make learning math an enjoyable journey for kids. The games are designed to be engaging and fun, fostering not just math skills but also critical thinking abilities. I’m thrilled to see it being helpful and inspiring growth through play.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF525252),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 1, // Profile is always index 1
        onIndexChanged: (index) {
          // Navigation is handled in the bottom navigation bar widget
        },
        user: user,
      ),
    );
  }
}
