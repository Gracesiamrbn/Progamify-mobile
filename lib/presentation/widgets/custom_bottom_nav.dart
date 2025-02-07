import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: const Color(0xFF6FBAFF),
      items: [
        _buildNavItem("assets/icons/nav_topic_icon.png"),
        _buildNavItem("assets/icons/nav_quest_icon.png"),
        _buildNavItem("assets/icons/nav_leaderboard_icon.png"),
        _buildNavItem("assets/icons/nav_profile_icon.png"),
      ],
    );
  }

  BottomNavigationBarItem _buildNavItem(String iconPath) {
    return BottomNavigationBarItem(
      icon: Image.asset(
        iconPath,
        width: 28,
        height: 28,
      ),
      label: '',
    );
  }
}