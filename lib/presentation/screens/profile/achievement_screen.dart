import 'package:flutter/material.dart';
import '../../widgets/achievement.dart';
import '../../../api/achievement_service.dart';

class AchievementScreen extends StatefulWidget {
  const AchievementScreen({super.key});

  @override
  _AchievementScreenState createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> {
  List<Map<String, dynamic>> achievements = [];

  final List<Map<String, dynamic>> defaultAchievements = [
    {
      "id": 1,
      "title": "Achievement Collector",
      "description": "Achieve the first 3 achievements",
      "picture": "assets/achievement/achievement_grey.svg",
    },
    {
      "id": 2,
      "title": "Ambitious Learner",
      "description": "Learning for 30 consecutive days",
      "picture": "assets/achievement/achievement_grey.svg",
    },
    {
      "id": 3,
      "title": "The Ultimate Achievement Hunter",
      "description": "Collect all available achievements",
      "picture": "assets/achievement/achievement_grey.svg",
    },
    {
      "id": 4,
      "title": "The Final Boss",
      "description": "Complete all the course",
      "picture": "assets/achievement/achievement_grey.svg",
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchAchievements();
  }

  Future<void> _fetchAchievements() async {
    try {
      // Ambil data dari API
      List<Map<String, dynamic>> apiAchievements = await AchievementsService().getAchievements();

      // Buat daftar ID dari response API
      Set<int> apiAchievementIds = apiAchievements.map((e) => e["id"] as int).toSet();

      // Filter defaultAchievements yang ID-nya tidak ada di API
      List<Map<String, dynamic>> missingAchievements = defaultAchievements
          .where((achievement) => !apiAchievementIds.contains(achievement["id"]))
          .toList();

      // Gabungkan hasil API + default yang hilang
      setState(() {
        achievements = [...apiAchievements, ...missingAchievements];
      });
    } catch (e) {
      print("Error fetching achievements: $e");
    }
  }

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
          'My Achievement',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: achievements.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Loading state
          : ListView.builder(
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
