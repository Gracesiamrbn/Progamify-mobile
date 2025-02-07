import 'package:flutter/material.dart';

class SummaryGrid extends StatelessWidget {
  final String title;
  final List<AchievementItem>? items;

  const SummaryGrid({
    super.key,
    this.title = "Summary",
    this.items,
  });

  @override
  Widget build(BuildContext context) {
    final achievements = items ??
        List.generate(
          4,
          (index) => AchievementItem(
            title: "Achievement ${index + 1}",
            description: "Description ${index + 1}",
          ),
        );

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
          Text(
            'Achievement',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio:
                  2, // Mengurangi perbandingan aspek untuk lebih rapat
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              final item = achievements[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(
                      4.0), // Mengurangi padding dalam item
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          color: Color(0xFF1F1F1F),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        item.description,
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
