import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../profile/public_profile_screen.dart';
import 'package:progamify/api/user_service.dart';
import 'package:progamify/api/leaderboard_service.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  late Future<Map<String, dynamic>> _futureUser;
  late Future<List<Map<String, dynamic>>> _futureLeaderboard;
  bool _showWinnerPopup = false;
  String _winnerName = "";

  // Audio
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isSoundPlayed = false;

  @override
  void initState() {
    super.initState();
    _futureUser = UserService().getCurrentUser();
    _futureLeaderboard = LeaderboardService().getLeaderboard();
    _checkIfUserIsWinner();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playSoundEffect(audioPath) async {
    if (!_isSoundPlayed) {
      print("[AUDIO] Playing sound: $audioPath");
      _isSoundPlayed = true;
      await _audioPlayer.play(AssetSource(audioPath));
      print("[AUDIO] Sound started: $audioPath");
    } else {
      print("[AUDIO] Sound already playing, skipping: $audioPath");
    }
  }

  void _stopSoundEffect() async {
    if (_audioPlayer.state == PlayerState.playing) {
      print("[AUDIO] Stopping sound...");
      await _audioPlayer.stop();
      await _audioPlayer.release();
      _isSoundPlayed = false;
      print("[AUDIO] Sound stopped and released.");
    }
  }

  Future<void> _checkIfUserIsWinner() async {
    try {
      final user = await _futureUser;
      final leaderboard = await _futureLeaderboard;

      debugPrint("Current User ID: ${user['ID']}");
      debugPrint("Leaderboard Top 1 ID: ${leaderboard[0]['ID']}");

      if (leaderboard.isNotEmpty && leaderboard[0]['ID'] == user['ID']) {
        setState(() {
          _showWinnerPopup = true;
          _winnerName = user['name'];
        });
      }
    } catch (e) {
      debugPrint("Error checking winner: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFEAF2FF),
      body: SafeArea(
        child: Stack(
          children: [
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _futureLeaderboard,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildSkeletonLeaderboard();
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Terjadi kesalahan: ${snapshot.error}"),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("Leaderboard kosong"));
                }

                final leaderboard = snapshot.data!;

                return Column(
                  children: [
                    const SizedBox(height: 20),
                    if (leaderboard.length >= 3)
                      _buildTopThreePodium(
                        leaderboard[0],
                        leaderboard[1],
                        leaderboard[2],
                      ),
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
                      child: _buildLeaderboardList(leaderboard),
                    ),
                  ],
                );
              },
            ),
            if (_showWinnerPopup) _buildWinnerPopup()
          ],
        ),
      ),
    );
  }

  Widget _buildWinnerPopup() {
    _playSoundEffect('audio/mixkit-grand-brass-fanfare-631.wav');
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Center(
        child: Stack(
          children: [
            Positioned.fill(
              child: Lottie.asset(
                'assets/animation/Animation - 1740197651611.json',
                fit: BoxFit.cover,
                repeat: true,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/animation/Animation - 1742200561611.json',
                          width: 200,
                          height: 200,
                          repeat: false,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          '🎉 Selamat! 🎉',
                          style: TextStyle(
                            fontSize: 22,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _winnerName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Kamu mendapat peringkat pertama di leaderboard!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        _stopSoundEffect();
                        setState(() {
                          _showWinnerPopup = false;
                        });
                      },
                      child: const Text(
                        'Lihat Leaderboard',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopThreePodium(firstRank, secondRank, thirdRank) {
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
                  secondRank,
                  size: 80,
                  position: 2,
                ),
                _buildPodiumUser(
                  firstRank,
                  size: 100,
                  position: 1,
                ),
                _buildPodiumUser(
                  thirdRank,
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

  Widget _buildShimmerUser({required double size, required int position}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Shimmer(
          duration: const Duration(seconds: 2),
          child: CircleAvatar(
            backgroundColor: Colors.grey[300],
            radius: size / 2,
          ),
        ),
        const SizedBox(height: 8),
        Shimmer(
          duration: const Duration(seconds: 2),
          child: Container(
            width: 60,
            height: 12,
            color: Colors.grey[300],
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildShimmerPodium() {
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
                _buildShimmerUser(size: 80, position: 2),
                _buildShimmerUser(size: 100, position: 1),
                _buildShimmerUser(size: 70, position: 3),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardList(List<Map<String, dynamic>> leaderboard) {
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

  Widget _buildSkeletonLeaderboard() {
    return Column(
      children: [
        const SizedBox(height: 20),
        _buildShimmerPodium(),
        const SizedBox(height: 16),
        Shimmer(
          duration: const Duration(seconds: 2),
          child: Container(
            width: 120,
            height: 20,
            color: Colors.grey[300],
          ),
        ),
        const SizedBox(height: 28),
        Expanded(
          child: ListView.builder(
            itemCount: 10, // Jumlah dummy skeleton list
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Shimmer(
                  duration: const Duration(seconds: 2),
                  child: Container(
                    height: 62,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

String firstLastName(fullName) {
  List<String> words = fullName.trim().split(' ');
  if (words.length == 1) return words[0];
  return '${words.first} ${words.last}';
}
