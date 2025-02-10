import 'package:flutter/material.dart';
import 'package:progamify/core/theme/app_styles.dart';
import '../../widgets/leaderboard.dart';

class LeaderboardScreen extends StatelessWidget {
  LeaderboardScreen({super.key});

  final List<Map<String, dynamic>> leaderboard = [
    {
      'name': 'John Doe',
      'xp': 273,
      'avatar': 'assets/avatars/avatar_male_1.png'
    },
    {
      'name': 'Jane Doe',
      'xp': 270,
      'avatar': 'assets/avatars/avatar_female_1.png'
    },
    {
      'name': 'James Doe',
      'xp': 262,
      'avatar': 'assets/avatars/avatar_male_2.png'
    },
    {
      'name': 'June Doe',
      'xp': 250,
      'avatar': 'assets/avatars/avatar_female_2.png'
    },
    {
      'name': 'Jay Doe',
      'xp': 249,
      'avatar': 'assets/avatars/avatar_male_3.png'
    },
    {
      'name': 'Jenny Doe',
      'xp': 247,
      'avatar': 'assets/avatars/avatar_female_3.png'
    },
    {
      'name': 'Jammy Doe',
      'xp': 240,
      'avatar': 'assets/avatars/avatar_male_4.png'
    },
    {
      'name': 'Joe Doe',
      'xp': 240,
      'avatar': 'assets/avatars/avatar_male_5.png'
    },
    {
      'name': 'Jessy Doe',
      'xp': 200,
      'avatar': 'assets/avatars/avatar_female_2.png'
    },
    {
      'name': 'Jerry Doe',
      'xp': 109,
      'avatar': 'assets/avatars/avatar_male_3.png'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTopUser(leaderboard[1]['name'], '🥈',
                      leaderboard[1]['avatar'], 60),
                  const SizedBox(width: 20.0),
                  _buildTopUser(leaderboard[0]['name'], '🥇',
                      leaderboard[0]['avatar'], 70),
                  const SizedBox(width: 20.0),
                  _buildTopUser(leaderboard[2]['name'], '🥉',
                      leaderboard[2]['avatar'], 50),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Leaderboard',
              style: AppStyles.title,
            ),
            const SizedBox(height: 10),
            // Memastikan Leaderboard bisa scrollable dengan Expanded tetap berfungsi
            SizedBox(
              height: MediaQuery.of(context).size.height -
                  200, // Sesuaikan tinggi agar konten lainnya tetap terlihat
              child: Leaderboard(leaderboard: leaderboard),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopUser(
      String? name, String medal, String? avatarPath, double avatarSize) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10), // Mengatur sudut membulat
          child: avatarPath != null
              ? Image.asset(
                  avatarPath,
                  width: avatarSize,
                  height: avatarSize,
                  fit: BoxFit.cover, // Menjaga aspek gambar
                )
              : Container(
                  width: avatarSize,
                  height: avatarSize,
                  color:
                      Colors.grey[300], // Warna background jika avatar kosong
                  child: const Icon(Icons.person, size: 40, color: Colors.grey),
                ),
        ),
        const SizedBox(height: 5),
        Text(name ?? 'Unknown', style: AppStyles.boldText),
        Text(medal, style: AppStyles.medalStyle),
      ],
    );
  }
}
