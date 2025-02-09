import 'package:flutter/material.dart';
import '../profile/profile_screen.dart';
import '../topic/topic_screen.dart';
import '../leaderboard/leaderboard_screen.dart';
import '../quest/quest_screen.dart';

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
    TopicsScreen(),
    const QuestScreen(),
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
      _currentIndex = index; // Ubah tab yang aktif berdasarkan index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        backgroundColor: Colors.blue[100],
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/nav/topics_nav.png', width: 30),
            label: 'Topics',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/nav/quests_nav.png', width: 30),
            label: 'Quests',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/nav/leaderboard_nav.png', width: 30),
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/nav/profile_nav.png', width: 30),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
