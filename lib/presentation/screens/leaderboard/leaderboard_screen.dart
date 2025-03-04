import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../profile/public_profile_screen.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:progamify/api/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> leaderboard = [];

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _fetchLeaderboard();
  }

  Future<void> _fetchLeaderboard() async {
    final String? _authToken = await _authService.getToken();

    try {
      final String baseUrl =
          dotenv.env["BASE_URL_API"] ?? "http://10.0.0.2/api";
      final response = await http.get(
        Uri.parse('$baseUrl/leaderboard'),
        headers: {
          'Authorization': 'Bearer $_authToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> LeaderboardList = json.decode(response.body);

        setState(() {
          leaderboard = LeaderboardList.map((leaderboard) => {
                'id': leaderboard['id'],
                'name': leaderboard['name'] ?? 'Unknown',
                'email': leaderboard['email'],
                'nim': leaderboard['nim'],
                'angkatan': leaderboard['angkatan'],
                'total_point': leaderboard['total_point'],
                'total_exp': leaderboard['total_exp'],
                'avatar': 'assets/avatars/avatar_male_1.svg',
              }).toList();
        });
      } else {
        setState(() {});
      }
    } catch (e) {
      setState(() {});
    }
  }

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
                  firstLastName(user['name']),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
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

    Duration shimmerDelay = isFirstPlace
        ? Duration.zero
        : isSecondPlace
            ? const Duration(milliseconds: 500)
            : isThirdPlace
                ? const Duration(milliseconds: 1000)
                : Duration.zero;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PublicProfileScreen(user: user),
          ),
        );
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          FutureBuilder(
            future:
                Future.delayed(shimmerDelay), // Tambahkan delay sesuai posisi
            builder: (context, snapshot) {
              bool shimmerEnabled =
                  snapshot.connectionState == ConnectionState.done;

              return Shimmer(
                duration: const Duration(seconds: 2),
                colorOpacity: 0.3,
                enabled: shimmerEnabled &&
                    (isFirstPlace || isSecondPlace || isThirdPlace),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                          child: Hero(
                            tag: user['name'],
                            child: SvgPicture.asset(
                              user['avatar'],
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
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
                              '${user['total_exp']}',
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
      ),
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

String firstLastName(fullName) {
  List<String> words = fullName.trim().split(' ');
  if (words.length == 1) return words[0];
  return '${words.first} ${words.last}';
}
