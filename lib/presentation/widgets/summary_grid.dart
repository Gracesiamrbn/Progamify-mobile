import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:progamify/presentation/screens/profile/achievement_screen.dart';

class SummaryGrid extends StatelessWidget {
  final String title;
  final List<Map<String, String>>? items;

  const SummaryGrid({
    super.key,
    this.title = "Summary",
    this.items,
  });

  void _showPopup(BuildContext context, Map<String, String> achievement) {
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
    final achievements = items ??
        [
          {
            "title": "First Step",
            "description": "Fully complete one Topic",
            "icon": "assets/achievement/walk_junior.svg",
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
        ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              title,
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
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.25,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              final achievement = achievements[index];

              return GestureDetector(
                onTap: () => _showPopup(
                    context, achievement), // Tambahkan GestureDetector
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F8FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black26),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Hero(
                        tag: achievement[
                            "icon"]!, // Hero tag harus unik untuk tiap item
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: SvgPicture.asset(
                            achievement["icon"]!,
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
          const SizedBox(height: 8),
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
                        builder: (context) => const AchievementScreen(),
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
}

class _PopupScreen extends StatelessWidget {
  final Map<String, String> achievement;

  const _PopupScreen({required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          Positioned(
            left: -100,
            right: -100,
            child: Center(
              child: Lottie.asset(
                'assets/animation/Animation - 1740191982184.json',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width + 200,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: achievement["icon"]!, // Hero harus punya tag yang sama
                    child: SvgPicture.asset(
                      achievement["icon"]!,
                      width: 210, // Ukuran lebih besar untuk efek transisi smooth
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
                  color: Colors.white.withOpacity(0.8),
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
