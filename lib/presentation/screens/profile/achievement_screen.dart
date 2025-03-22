import 'package:flutter/material.dart';
import '../../widgets/achievement.dart';

class AchievementScreen extends StatelessWidget {
  const AchievementScreen({super.key});

  static List<Map<String, String>> achievements = [
    {
      "title": "First Step",
      "description": "Fully complete one Topic",
      "icon": "assets/achievement/walk_beginner.svg",
    },
    {
      "title": "Badge Collector",
      "description": "Earn your first Badge",
      "icon": "assets/achievement/badge_.svg",
    },
    {
      "title": "Avatar Explorer",
      "description": "Unlock your first Avatar.",
      "icon": "assets/achievement/Beginner.svg",
    },
    {
      "title": "Badge Hunter",
      "description": "Collect 5 Badges.",
      "icon": "assets/achievement/badge_junior.svg",
    },
    {
      "title": "Avatar Upgrader",
      "description": "Unlock 3 avatars",
      "icon": "assets/achievement/junior.svg",
    },
    {
      "title": "Topic Conqueror",
      "description": "Fully complete 5 Topics.",
      "icon": "assets/achievement/walk_junior.svg",
    },
    {
      "title": "Perfectionist ",
      "description": "Achieve a perfect score (100%) in a Topic",
      "icon": "assets/achievement/ok_.svg",
    },
    {
      "title": "The Ultimate Badge Hunter",
      "description": "Collect all available Badges.",
      "icon": "assets/achievement/badge_expert.svg",
    },
    {
      "title": "The Final Boss",
      "description": "Complete every Topic & Exercise in the platform.",
      "icon": "assets/achievement/verif_expert.svg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4285F4),
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Achievement',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter'),
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
