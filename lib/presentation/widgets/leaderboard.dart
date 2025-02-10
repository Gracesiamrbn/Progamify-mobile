import 'package:flutter/material.dart';
import 'package:progamify/core/theme/app_styles.dart';

class Leaderboard extends StatelessWidget {
  final List<Map<String, dynamic>> leaderboard;

  const Leaderboard({super.key, required this.leaderboard});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(),
      itemCount: leaderboard.length,
      itemBuilder: (context, index) {
        final user = leaderboard[index];
        return ListTile(
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '#${index + 1}',
                style: AppStyles.leaderboardRank,
              ),
              const SizedBox(width: 30),
              CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage(user['avatar']),
                radius: 20,
              ),
              const SizedBox(width: 20),
            ],
          ),
          title: Text(
            user['name'],
            style: AppStyles.boldText,
          ),
          trailing: Text(
            '${user['xp']} XP',
            style: AppStyles.boldText,
          ),
          tileColor: index % 2 == 0
              ? const Color(0xFFFFB37C)
              : const Color(0xFFFFF4E4),
        );
      },
    );
  }
}
