import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  LeaderboardScreenState createState() => LeaderboardScreenState();
}

class LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> leaderboard = [
    {
      'name': 'Enrico Sirait',
      'xp': 273,
      'avatar': 'assets/avatars/avatar_male_1.svg',
      'hasTrophy': true,
    },
    {
      'name': 'Emely Angelica',
      'xp': 270,
      'avatar': 'assets/avatars/avatar_female_1.svg',
      'hasTrophy': false,
    },
    {
      'name': 'Boy Sitorus',
      'xp': 262,
      'avatar': 'assets/avatars/avatar_male_2.svg',
      'hasTrophy': false,
    },
    {
      'name': 'Tabitha Acquila',
      'xp': 250,
      'avatar': 'assets/avatars/avatar_female_2.svg',
      'hasTrophy': false,
    },
    {
      'name': 'Benhard Yudha',
      'xp': 249,
      'avatar': 'assets/avatars/avatar_male_3.svg',
      'hasTrophy': false,
    },
    {
      'name': 'Tesalonika Aprisda',
      'xp': 247,
      'avatar': 'assets/avatars/avatar_female_3.svg',
      'hasTrophy': false,
    },
    {
      'name': 'Rafael Manurung',
      'xp': 240,
      'avatar': 'assets/avatars/avatar_male_4.svg',
      'hasTrophy': false,
    },
    {
      'name': 'Gerry Bukit',
      'xp': 240,
      'avatar': 'assets/avatars/avatar_male_5.svg',
      'hasTrophy': false,
    },
    {
      'name': 'Icha Samosir',
      'xp': 200,
      'avatar': 'assets/avatars/avatar_female_4.svg',
      'hasTrophy': false,
    },
    {
      'name': 'Agustina Butarbutar',
      'xp': 200,
      'avatar': 'assets/avatars/avatar_female_6.svg',
      'hasTrophy': false,
    },
    // {
    //   'name': 'Dwi Paranggi Purba',
    //   'xp': 199,
    //   'avatar': 'assets/avatars/avatar_male_6.svg',
    //   'hasTrophy': false,
    // },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.from(alpha: 1, red: 0.918, green: 0.949, blue: 1),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildTopThreePodium(),
            const SizedBox(height: 16),
            const Text(
              'Leaderboard',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _buildLeaderboardList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopThreePodium() {
    return SizedBox(
      height: 180,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildPodiumUser(
                  leaderboard[1],
                  size: 80,
                  position: 2,
                ),
                _buildPodiumUser(
                  leaderboard[0],
                  size: 100,
                  position: 1,
                ),
                _buildPodiumUser(
                  leaderboard[2],
                  size: 70,
                  position: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumUser(Map<String, dynamic> user,
      {required double size, required int position}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: SvgPicture.asset(
                      user['avatar'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user['name'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            // if (position == 1)
            //   Positioned(
            //     top: 70,
            //     child: Transform.scale(
            //       scale: 1.1,
            //       child: SvgPicture.asset(
            //         'assets/leaderboard/trophy_badge.svg',
            //         width: 42,
            //         height: 42,
            //       ),
            //     ),
            //   ),
            // if (position == 2)
            //   Positioned(
            //     top: 54,
            //     left: 30,
            //     child: Transform.scale(
            //       scale: 0.85,
            //       child: SvgPicture.asset(
            //         'assets/leaderboard/trophy_badge_2.svg',
            //         width: 42,
            //         height: 42,
            //       ),
            //     ),
            //   ),
            // if (position == 3)
            //   Positioned(
            //     top: 41,
            //     left: 17.5,
            //     child: Transform.scale(
            //       scale: 0.75,
            //       child: SvgPicture.asset(
            //         'assets/leaderboard/trophy_badge_3.svg',
            //         width: 42,
            //         height: 42,
            //       ),
            //     ),
            //   ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildLeaderboardList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: leaderboard.length,
      itemBuilder: (context, index) {
        final user = leaderboard[index];

        return FutureBuilder(
            future: Future.delayed(Duration(milliseconds: index * 300)),
            builder: (context, snapshot) {
              bool isVisible = snapshot.connectionState == ConnectionState.done;

              return AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: isVisible ? 1.0 : 0.0,
                child: Transform.scale(
                  scale: isVisible ? 1.0 : 0.0,
                  child: _buildLeaderboardItem(user, index + 1),
                ),
              );
            });
      },
    );
  }

  Widget _buildLeaderboardItem(Map<String, dynamic> user, int position) {
    bool isFirstPlace = position == 1;
    bool isSecondPlace = position == 2;
    bool isThirdPlace = position == 3;

    // Durasi delay berbeda untuk setiap posisi
    Duration shimmerDelay = isFirstPlace
        ? Duration.zero
        : isSecondPlace
            ? const Duration(milliseconds: 500)
            : isThirdPlace
                ? const Duration(milliseconds: 1000)
                : Duration.zero;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        FutureBuilder(
          future: Future.delayed(shimmerDelay), // Tambahkan delay sesuai posisi
          builder: (context, snapshot) {
            bool shimmerEnabled =
                snapshot.connectionState == ConnectionState.done;

            return Shimmer(
              duration: const Duration(seconds: 2),
              colorOpacity: 0.3,
              enabled: shimmerEnabled &&
                  (isFirstPlace || isSecondPlace || isThirdPlace),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: _getItemColor(position),
                  borderRadius: BorderRadius.circular(12),
                  gradient: isFirstPlace
                      ? LinearGradient(
                          colors: [Colors.amber[300]!, Colors.yellow[100]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 30,
                        child: !isFirstPlace
                            ? Text(
                                '#$position',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isSecondPlace
                                      ? const Color(0xFF4682B4)
                                      : isThirdPlace
                                          ? const Color(0xFF800000)
                                          : Colors.black,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      ClipOval(
                        child: SvgPicture.asset(
                          user['avatar'],
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          user['name'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isFirstPlace
                                ? Colors.amber[900]
                                : isSecondPlace
                                    ? const Color(0xFF4682B4)
                                    : isThirdPlace
                                        ? const Color(0xFF800000)
                                        : Colors.black,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${user['xp']}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF6B3FA0),
                            ),
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Image.asset(
                            'assets/icons/exp_point.png',
                            width: 20,
                            height: 20,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        if (isFirstPlace)
          Positioned(
            left: 5,
            top: -5,
            child: Image.asset(
              'assets/leaderboard/trophy_gold.png',
              width: 84,
              height: 84,
            ),
          ),
      ],
    );
  }

  Color _getItemColor(int position) {
    switch (position) {
      case 1:
        return const Color(0xFFFFE4A1);
      case 2:
        return const Color(0xFFD3D3D3);
      case 3:
        return const Color(0xFFE6B8A2);
      default:
        return const Color(0xFFC8E2F3);
    }
  }
}
