import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:progamify/presentation/screens/navigation/bottom_navigation.dart';

// import '../screens/quest/quest_screen.dart';

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
    final badges = items ??
        List.generate(
          4,
          (index) => BadgeItem(
            color: Colors.orange,
            iconPath: "assets/badges/badge_${index + 1}.png",
          ),
        );

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
              return Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: badge.color,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.0),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: badge.iconPath != null
                    ? Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Image.asset(
                          badge.iconPath!,
                          fit: BoxFit.contain,
                        ),
                      )
                    : null,
              );
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
                              const MainScreen(currentIndex: 1)),
                    );
                  },
              ),
            ),
          ),

          const SizedBox(height: 16), // Jarak di bawah section
        ],
      ),
    );
  }
}

class BadgeItem {
  final Color color;
  final String? iconPath;

  BadgeItem({
    required this.color,
    this.iconPath,
  });
}
