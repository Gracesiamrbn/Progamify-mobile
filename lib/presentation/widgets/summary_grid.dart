import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
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
          },
          {
            "title": "Badge Collector",
            "description": "Earn your first Badge",
          },
          {
            "title": "Avatar Explorer",
            "description": "Unlock your first Avatar.",
          },
          {
            "title": "Badge Hunter",
            "description": "Collect 5 Badges.",
          },
          // Add more achievements as needed
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
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              final achievement = achievements[index];
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.grey.shade300,
                      Colors.grey.shade500,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12, // Bayangan yang lebih lembut dan besar
                      offset: Offset(0, 6), // Posisi bayangan yang lebih halus
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        achievement["title"]!,
                        style: const TextStyle(
                          color: Color(0xFF1F1F1F),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        achievement["description"]!,
                        style: const TextStyle(
                          color: Color(0xFF1F1F1F),
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
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
                          builder: (context) => const AchievementScreen()),
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

class AchievementItem {
  final String title;
  final String description;

  AchievementItem({
    required this.title,
    required this.description,
  });
}
