import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:progamify/presentation/screens/profile/achievement_screen.dart';

class SummaryGrid extends StatelessWidget {
  final String title;
  final List<Map<String, String>>? items;

  const SummaryGrid({
    super.key,
    this.title = "Summary",
    this.items,
  });

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

              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black26),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: SvgPicture.asset(
                        achievement["icon"]!,
                        width: 50,
                        height: 50,
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
