import 'package:flutter/material.dart';
import '../../widgets/achievement.dart';
import '../../../api/achievement_service.dart';

class PublicAchievementScreen extends StatefulWidget {
  final int userId;

  const PublicAchievementScreen({
    super.key,
    required this.userId,
  });

  @override
  _PublicAchievementScreenState createState() =>
      _PublicAchievementScreenState();
}

class _PublicAchievementScreenState extends State<PublicAchievementScreen> {
  final AchievementsService _achievementsService = AchievementsService();
  List<Map<String, dynamic>> _achievements = [];
  bool _isLoading = true;

  final List<Map<String, dynamic>> defaultAchievements = [
    {
      "id": 1,
      "title": "Badge Collector",
      "description": "Achieve the first 3 badges",
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
      "title": "The Ultimate Badge Hunter",
      "description": "Collect all available badges",
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
      final data =
          await _achievementsService.getAchievementsByUserId(widget.userId);

      if (data.isEmpty) {
        setState(() {
          _achievements = defaultAchievements;
          _isLoading = false;
        });
        return;
      }

      Map<int, Map<String, dynamic>> achievementMap = {
        for (var achievement in data) achievement['id']: achievement
      };

      setState(() {
        _achievements = defaultAchievements.map((achievement) {
          return achievementMap.containsKey(achievement["id"])
              ? achievementMap[achievement["id"]]!
              : achievement;
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _achievements = defaultAchievements;
        _isLoading = false;
      });
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
          'Achievement',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _achievements.length,
              itemBuilder: (context, index) {
                final achievement = _achievements[index];
                return AchievementItem(achievement: achievement);
              },
            ),
    );
  }
}
