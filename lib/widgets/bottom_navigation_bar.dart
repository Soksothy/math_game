import 'package:flutter/material.dart';
import '../models/user_model.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onIndexChanged;
  final UserModel? user;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        gradient: LinearGradient(
          colors: [
            Color(0xFFFFFBF2),
            Color(0xFFFFF9E8),
            Color(0xFFFFF0D6),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.15),
            offset: Offset(0, -2),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(context, 'cart.png', 0),
            _buildNavItem(context, 'profile.png', 1),
            SizedBox(
              width: 55,
              height: 55,
              child: IconButton(
                icon: Image.asset('lib/asset/home.png', width: 35, height: 35),
                onPressed: () {
                  onIndexChanged(2);
                  if (user != null) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/home',
                      (route) => false,
                      arguments: {'userModel': user},
                    );
                  }
                },
                splashColor: Colors.orange.withOpacity(0.3),
                hoverColor: Colors.orange.withOpacity(0.1),
              ),
            ),
            _buildNavItem(context, 'leaderboard.png', 3),
            _buildNavItem(context, 'settings.png', 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String asset, int index) {
    final isSelected = selectedIndex == index;
    return InkWell(
      onTap: () {
        onIndexChanged(index);
        if (user == null) return;
        String route = '/home';
        switch (index) {
          case 0:
            route = '/shop';
            break;
          case 1:
            route = '/profile';
            break;
          case 2:
            route = '/home';
            break;
          case 3:
            route = '/leaderboard';
            break;
          case 4:
            route = '/settings';
            break;
        }
        Navigator.of(context).pushNamedAndRemoveUntil(
          route,
          (route) => false,
          arguments: {'userModel': user},
        );
      },
      borderRadius: BorderRadius.circular(12),
      splashColor: Colors.orange.withOpacity(0.3),
      highlightColor: Colors.orange.withOpacity(0.1),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Colors.orange.withOpacity(0.1) : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'lib/asset/$asset',
              width: 35,
              height: 35,
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 3),
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFAF57),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFFFAF57),
                      blurRadius: 4,
                      spreadRadius: 0.5,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}