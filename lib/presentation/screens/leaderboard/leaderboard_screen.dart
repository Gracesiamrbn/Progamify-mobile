import 'package:flutter/material.dart';
import 'package:progamify/core/theme/app_styles.dart';
// import 'package:google_fonts/google_fonts.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Leaderboard',
                  style: AppStyles.headingStyle,
                ),
                SizedBox(height: 4),
                Text(
                  'SEE WHO IS ON TOP !',
                  style: AppStyles.instructionStyle,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Misalnya 10 pemain di leaderboard
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade300,
                    child: Text(
                      '${index + 1}',
                      style: AppStyles.boldWhite,
                    ),
                  ),
                  title: Text(
                    'Player ${index + 1}',
                    style: AppStyles.bodyStyle,
                  ),
                  subtitle: Text('Points: ${1000 - (index * 100)}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
