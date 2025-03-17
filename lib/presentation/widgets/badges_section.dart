import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:progamify/presentation/screens/navigation/bottom_navigation.dart';

import '../screens/quest/quest_menu_screen.dart';

class BadgesSection extends StatelessWidget {
  final String title;
  final List<BadgeItem>? items;

  const BadgesSection({
    super.key,
    this.title = "Badges",
    this.items,
  });

  @override
  Widget build(BuildContext context) {
    // final badges = items ??
    //     List.generate(
    //       4,
    //       (index) => BadgeItem(
    //         color: Colors.orange,
    //         iconPath: "assets/badges/badge_${index + 1}.png",
    //       ),
    //     );

    final badges = items ??
        [
          BadgeItem(badgePath: "assets/badges/task_tackler.svg"),
          BadgeItem(badgePath: "assets/badges/quest_beginner.svg"),
          BadgeItem(badgePath: "assets/badges/mission_veteran.svg"),
          BadgeItem(
              badgePath:
                  "assets/badges/starter_badge.svg"), // Jika ada badge tambahan
        ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: badges.map((badge) {
              return badge.badgePath != null
                  ? SvgPicture.asset(
                      badge.badgePath!,
                      fit: BoxFit.contain,
                      width: 80,
                      height: 80,
                    )
                  : const SizedBox(width: 64, height: 64);
            }).toList(),
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const MainScreen(currentIndex: 1, tabIndex: 1)),
                    );
                  },
              ),
            ),
          ),

          const SizedBox(height:86), // Jarak di bawah section
        ],
      ),
    );
  }
}

class BadgeItem {
  final String? badgePath;

  BadgeItem({
    this.badgePath,
  });
}
