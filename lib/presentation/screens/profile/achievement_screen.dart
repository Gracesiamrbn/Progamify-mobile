import 'package:flutter/material.dart';
import '../../widgets/achievement.dart';

class AchievementScreen extends StatelessWidget {
  const AchievementScreen({super.key});

  static List<Map<String, String>> achievements = [
    {
      "title": "First Step",
      "description": "Fully complete one Topic",
      "icon": "",
    },
    {
      "title": "Badge Collector",
      "description": "Earn your first Badge",
      "icon": "",
    },
    {
      "title": "Avatar Explorer",
      "description": "Unlock your first Avatar.",
      "icon": "",
    },
    {
      "title": "Badge Hunter",
      "description": "Collect 5 Badges.",
      "icon": "",
    },
    {
      "title": "Avatar Upgrader",
      "description": "Unlock 3 avatars",
      "icon": "",
    },
    {
      "title": "Topic Conqueror",
      "description": "Fully complete 5 Topics.",
      "icon": "",
    },
    {
      "title": "Perfectionist ",
      "description": "Achieve a perfect score (100%) in a Topic",
      "icon": "",
    },
    {
      "title": "The Ultimate Badge Hunter",
      "description": "Collect all available Badges.",
      "icon": "",
    },
    {
      "title": "The Final Boss",
      "description": "Complete every Topic & Exercise in the platform.",
      "icon": "",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Achievement', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          final achievement = achievements[index];
          return AchievementItem(achievement: achievement);
        },
      ),
    );
  }
}
