import 'package:flutter/material.dart';

class AchievementItem extends StatelessWidget {
  final Map<String, String> achievement;

  const AchievementItem({super.key, required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade300,
            Colors.grey.shade500,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18), // Sudut lebih bulat
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12, // Bayangan yang lebih lembut dan besar
            offset: Offset(0, 6), // Posisi bayangan yang lebih halus
          ),
        ],
      ),
      child: Row(
        children: [
          // Kolom untuk judul dan deskripsi
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  achievement["title"]!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  achievement["description"]!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
