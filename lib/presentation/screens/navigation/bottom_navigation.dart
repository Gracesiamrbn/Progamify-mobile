import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../profile/profile_screen.dart';
import '../topic/topic_screen.dart';
import '../leaderboard/leaderboard_screen.dart';
import '../quest/quest_menu_screen.dart';

class MainScreen extends StatefulWidget {
  final int currentIndex;
  const MainScreen({super.key, this.currentIndex = 0});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  // Daftar screens yang akan ditampilkan
  final List<Widget> _screens = [
    const TopicsScreen(),
    const QuestScreen(initialTabIndex: 0),
    const LeaderboardScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _screens[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: const Color(0xFF6FBAFF),
        buttonBackgroundColor: Colors.white.withOpacity(0.8),
        animationDuration: const Duration(milliseconds: 700),
        height: 60,
        index: _currentIndex,
        items: [
          Image.asset('assets/nav/topics_nav.png', width: 30),
          Image.asset('assets/nav/quests_nav.png', width: 30),
          Image.asset('assets/nav/leaderboard_nav.png', width: 30),
          Image.asset('assets/nav/profile_nav.png', width: 30),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
