import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onIndexChanged;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74, // Increased from 70 to 74
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
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6), // Reduced vertical padding
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem('cart.png', 0),
            _buildNavItem('profile.png', 1),
            SizedBox(
              width: 55, // Increased from 50
              height: 55, // Increased from 50
              child: IconButton(
                icon: Image.asset('lib/asset/home.png', width: 35, height: 35), // Increased from 30
                onPressed: () => onIndexChanged(2),
                splashColor: Colors.orange.withOpacity(0.3),
                hoverColor: Colors.orange.withOpacity(0.1),
              ),
            ),
            _buildNavItem('leaderboard.png', 3),
            _buildNavItem('settings.png', 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String asset, int index) {
    final isSelected = selectedIndex == index;
    return InkWell(
      onTap: () => onIndexChanged(index),
      borderRadius: BorderRadius.circular(12),
      splashColor: Colors.orange.withOpacity(0.3),
      highlightColor: Colors.orange.withOpacity(0.1),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // Reduced vertical padding
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Colors.orange.withOpacity(0.1) : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'lib/asset/$asset',
              width: 35, // Increased from 32
              height: 35, // Increased from 32
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 3), // Reduced from 4
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
