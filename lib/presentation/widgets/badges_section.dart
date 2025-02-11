import 'package:flutter/material.dart';

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
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        Colors.white.withOpacity(0.0), // Frame putih transparan
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
                        padding: const EdgeInsets.all(4.0),
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
              text: const TextSpan(
                text: 'see more...',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.25,
                ),
                // recognizer: TapGestureRecognizer()
                //   ..onTap = () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => const QuestScreen()),
                //     );
                //   },
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
