import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../profile/profile_screen.dart';
import '../topic/topic_screen.dart';
import '../leaderboard/leaderboard_screen.dart';
import '../quest/quest_menu_screen.dart';

class MainScreen extends StatefulWidget {
  final int currentIndex;
  final int? tabIndex;

  const MainScreen({super.key, this.currentIndex = 0, this.tabIndex});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  late int _currentIndex;
  late int _tabIndex; // Gunakan late agar diinisialisasi di initState()

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    _tabIndex = widget.tabIndex ?? 0; // Gunakan tabIndex dari widget jika ada
  }

  final List<Color> _navColors = [
    const Color(0xFF6FBAFF),
    const Color(0xFFD2B48C),
    const Color(0xFFF5C97C),
    const Color(0xFF6FBAFF),
  ];

  // Method untuk mendapatkan screen berdasarkan index
  Widget getScreen(int index) {
    switch (index) {
      case 0:
        return const TopicsScreen();
      case 1:
        return QuestScreen(initialTabIndex: _tabIndex);
      case 2:
        return const LeaderboardScreen();
      case 3:
        return const ProfileScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 1) {
        _tabIndex =
            0; // Reset tab ke default (tab "Badge") setiap kali QuestScreen dibuka
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      extendBody: true,
      body: Column(
        children: [
          Expanded(
              child:
                  getScreen(_currentIndex)), // Pastikan layar anak terisi penuh
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: _navColors[_currentIndex],
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
    ));
  }
}
