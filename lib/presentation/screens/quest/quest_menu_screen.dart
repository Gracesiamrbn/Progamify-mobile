import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:progamify/presentation/screens/quest/quest_excercise_screen.dart';
import 'package:progamify/api/user_service.dart';
import 'package:progamify/api/quest_service.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../api/badge_service.dart';

class QuestScreen extends StatefulWidget {
  final int initialTabIndex;
  const QuestScreen({super.key, this.initialTabIndex = 1});

  @override
  QuestScreenState createState() => QuestScreenState();
}

class QuestScreenState extends State<QuestScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: widget.initialTabIndex,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            backgroundColor: const Color.fromARGB(255, 250, 226, 217),
            automaticallyImplyLeading: false, // Menonaktifkan tombol back
            bottom: TabBar(
              indicatorColor: Colors.brown[300],
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.black, // Warna teks tab yang aktif
              unselectedLabelColor:
                  Colors.grey, // Warna teks tab yang tidak aktif
              tabs: const [
                Tab(text: 'Quests'),
                Tab(text: 'Badges'),
              ],
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            QuestTab(),
            BadgesTab(),
          ],
        ),
      ),
    );
  }
}

class QuestTab extends StatefulWidget {
  const QuestTab({super.key});

  @override
  _QuestTabState createState() => _QuestTabState();
}

class _QuestTabState extends State<QuestTab> {
  late Future<Map<String, dynamic>> _userFuture;
  late QuestService _questService;

  int userLevel = 0;
  int totalExp = 0;
  int? expNeeded;
  double progress = 0.0;
  bool animateProgress = false;

  @override
  void initState() {
    super.initState();
    _userFuture = UserService().getCurrentUser();
    _questService = QuestService();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await UserService().getCurrentUser();
      int levelId = userData['level_id'];
      totalExp = userData['total_exp'];

      final levelData = await _questService.getLevel(levelId);
      int expForCurrentLevel = levelData['exp_needed'];
      int initExp = totalExp - expForCurrentLevel;
      int fetchedLevel = levelData['level'];

      bool hasNextLevel = levelData.containsKey('next_level') &&
          levelData['next_level'] != null;

      expNeeded = hasNextLevel
          ? levelData['next_level']['exp_needed'] - expForCurrentLevel
          : 0;

      double newProgress =
          hasNextLevel ? ((initExp / (expNeeded ?? 1)).clamp(0.0, 1.0)) : 1.0;

      setState(() {
        userLevel = fetchedLevel;
      });

      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          animateProgress = true;
          progress = newProgress;
        });
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildQuestHeader(),
              const SizedBox(height: 20),
              _buildInstructionContainer(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestHeader() {
    return Shimmer(
      color: const Color(0xFFF2C6A0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFB88A66),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quest of the Week',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Complete the quest to gain more XP!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TweenAnimationBuilder<double>(
                          duration: const Duration(seconds: 2),
                          curve: Curves.easeOut,
                          tween: Tween<double>(
                            begin: 0,
                            end: animateProgress ? progress : 0,
                          ),
                          builder: (context, value, child) {
                            return LinearProgressIndicator(
                              value: value,
                              backgroundColor: Colors.white,
                              color: const Color(0xFFFFC107),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      TweenAnimationBuilder<int>(
                        duration: const Duration(seconds: 2),
                        tween: IntTween(
                          begin: 0,
                          end: animateProgress ? (progress * 100).toInt() : 0,
                        ),
                        builder: (context, value, child) {
                          return Text(
                            '$value%',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  const Text(
                    'Level',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD2691E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  TweenAnimationBuilder<int>(
                    duration: const Duration(seconds: 1),
                    tween: IntTween(begin: 0, end: userLevel),
                    builder: (context, value, child) {
                      return Text(
                        '$value',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD2691E),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionContainer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFD2B48C),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'Instruction',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Complete a random quest to upgrade your level and gain a badge. The higher your level, the harder the quest you’ll likely get.',
            style: TextStyle(fontSize: 14, fontFamily: 'Inter'),
          ),
          const SizedBox(height: 8),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontFamily: 'Inter'), // Default style
              children: [
                TextSpan(text: 'There are 3 types of quest: '),
                TextSpan(
                  text: 'easy',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green),
                ),
                TextSpan(text: ', '),
                TextSpan(
                  text: 'medium',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 211, 13)),
                ),
                TextSpan(text: ', '),
                TextSpan(
                  text: 'hard',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontFamily: 'Inter'), // Default style
              children: [
                TextSpan(
                    text:
                        'When you achieve certain criteria, you will gain a '),
                TextSpan(
                  text: 'badge.',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.amber),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Click the play icon button to start today’s random quest.',
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomRight,
            child: FutureBuilder<Map<String, dynamic>>(
                future: _userFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const FloatingActionButton(
                      backgroundColor: Colors.grey,
                      onPressed: null, // Tidak bisa ditekan saat loading
                      child: Icon(Icons.hourglass_empty, color: Colors.white),
                    );
                  } else if (snapshot.hasError) {
                    return const FloatingActionButton(
                      backgroundColor: Colors.red,
                      onPressed: null, // Tidak bisa ditekan saat error
                      child: Icon(Icons.error, color: Colors.white),
                    );
                  } else if (!snapshot.hasData) {
                    return const FloatingActionButton(
                      backgroundColor: Colors.grey,
                      onPressed: null,
                      child: Icon(Icons.warning, color: Colors.white),
                    );
                  }
                  int userId = snapshot.data!['ID'];

                  return FloatingActionButton(
                    backgroundColor: const Color(0xFFB88A66),
                    child: const Icon(Icons.play_arrow,
                        color: Colors.white, size: 30),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              QuestExcerciseScreen(userId: userId),
                        ),
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class BadgesTab extends StatefulWidget {
  const BadgesTab({super.key});

  @override
  _BadgesTabState createState() => _BadgesTabState();
}

class _BadgesTabState extends State<BadgesTab> {
  late Future<List<Map<String, dynamic>>> _badgesFuture;

  @override
  void initState() {
    super.initState();
    _badgesFuture = BadgesService().getBadges();
  }

  Widget build(BuildContext context) {
    // Daftar badge default (jika belum diperoleh)
    final List<Map<String, dynamic>> defaultBadges = [
      {
        "id": 1,
        "title": "Quest Beginner",
        "description": "Complete 10 quest for the first time",
        "picture": "assets/badges/quest_beginner_grey.svg"
      },
      {
        "id": 2,
        "title": "Warrior",
        "description": "Fall seven times, rise eight times",
        "picture": "assets/badges/warrior_grey.svg"
      },
      {
        "id": 3,
        "title": "Triple Win",
        "description": "Complete 3 consecutive quests perfectly",
        "picture": "assets/badges/triple_win_grey.svg"
      },
      {
        "id": 4,
        "title": "Ultimate Five",
        "description": "Complete 5 consecutive streaks perfectly",
        "picture": "assets/badges/ultimate_five_grey.svg"
      },
      {
        "id": 5,
        "title": "Legendary Ten",
        "description": "Complete 10 consecutive quests perfectly",
        "picture": "assets/badges/legendary_ten_grey.svg"
      },
      {
        "id": 6,
        "title": "Unstoppable Challenger",
        "description": "No Skips No Excuses - 7 days of quest mastery",
        "picture": "assets/badges/unstoppable_challenger_grey.svg"
      }
    ];

    return Container(
      color: Colors.orange[50],
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _badgesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData ||
              snapshot.data!.isEmpty ||
              snapshot.data == null) {
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          // Data API yang didapat
          final apiBadges = snapshot.data ?? [];

          // Gabungkan data API dengan default badges
          final combinedBadges = defaultBadges.map((defaultBadge) {
            // Cek apakah badge ini ada di API
            final foundBadge = apiBadges.firstWhere(
              (badge) => badge["id"] == defaultBadge["id"],
              orElse: () => defaultBadge, // Jika tidak ada, pakai default badge
            );

            // Jika ditemukan di API, pakai gambar aslinya & tambahkan count
            return {
              "id": foundBadge["id"],
              "title": foundBadge["title"],
              "description": foundBadge["description"],
              "picture": foundBadge.containsKey("count")
                  ? foundBadge["picture"]
                  : defaultBadge["picture"],
              "count":
                  foundBadge["count"] ?? 0, // Default count 0 jika tidak ada
            };
          }).toList();

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8,
            ),
            itemCount: combinedBadges.length,
            itemBuilder: (context, index) {
              final badge = combinedBadges[index];

              return GestureDetector(
                onTap: () => _showBadgePopup(context, badge),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SvgPicture.asset(
                              badge["picture"],
                              width: 120,
                              height: 120,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        // Tampilkan count hanya jika lebih dari 0
                        if (badge["count"] > 0)
                          Positioned(
                            top: 5,
                            right: 5,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              child: Text(
                                'x${badge["count"]}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: 120,
                      child: Text(
                        badge["title"],
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showBadgePopup(BuildContext context, Map<String, dynamic> badge) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SvgPicture.asset(
                  badge["picture"],
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                badge["title"],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                badge["description"], // Menampilkan deskripsi
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                decoration: BoxDecoration(
                  color:
                      (badge["count"] == 0) ? Colors.grey.shade400 : Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Jumlah: ${badge["count"]}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      (badge["count"] == 0) ? Colors.grey : Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  "Close",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class BadgeItemData {
  final String imagePath;
  final String title;
  final String subtitle;

  BadgeItemData(
      {required this.imagePath, required this.title, required this.subtitle});
}
