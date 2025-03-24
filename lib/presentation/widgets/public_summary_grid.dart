import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:progamify/presentation/screens/profile/public_achievement_screen.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../api/achievement_service.dart';

class PublicSummaryGrid extends StatefulWidget {
  final String title;
  final int userId;

  const PublicSummaryGrid({
    super.key,
    required this.userId,
    this.title = "PublicSummary",
  });

  @override
  _PublicSummaryGridState createState() => _PublicSummaryGridState();
}

class _PublicSummaryGridState extends State<PublicSummaryGrid> {
  final AchievementsService _achievementsService = AchievementsService();
  List<Map<String, dynamic>> _achievements = [];
  bool _isLoading = true;

  final defaultAchievements = [
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

  void _showPopup(BuildContext context, Map<String, dynamic> achievement) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => _PopupScreen(achievement: achievement),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutBack,
                ),
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Achievement',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          _isLoading
              ? buildSkeletonGridView()
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2.25,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _achievements.length,
                  itemBuilder: (context, index) {
                    final achievement = _achievements[index];

                    return GestureDetector(
                      onTap: () => _showPopup(context, achievement),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F8FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black26),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Hero(
                              tag: achievement[
                                  "id"]!, 
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: SvgPicture.asset(
                                  achievement["picture"]!,
                                  width: 50,
                                  height: 50,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    achievement["title"]!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    achievement["description"]!,
                                    style: const TextStyle(
                                      fontSize: 8,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          const SizedBox(
            height: 8,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: RichText(
              text: TextSpan(
                text: 'see more...',
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.25,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PublicAchievementScreen(
                          userId: widget.userId,
                        ),
                      ),
                    );
                  },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSkeletonGridView() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.25,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Shimmer(
          color: Colors.white,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black26),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 12,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 8,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PopupScreen extends StatelessWidget {
  final Map<String, dynamic> achievement;

  const _PopupScreen({required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: achievement["id"]!, 
                    child: SvgPicture.asset(
                      achievement["picture"]!,
                      width:
                          210,
                      height: 210,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    achievement["title"]!,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      achievement["description"]!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.withOpacity(0.2),
                ),
                child: const Icon(Icons.close, size: 30, color: Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
