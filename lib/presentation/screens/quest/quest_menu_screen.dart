import 'package:flutter/material.dart';
import 'package:progamify/presentation/screens/quest/quest_excercise_screen.dart';
import 'package:progamify/api/user_service.dart';
import 'package:progamify/api/quest_service.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

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
          preferredSize:
              const Size.fromHeight(50), // Menyembunyikan space AppBar
          child: AppBar(
            automaticallyImplyLeading: false, // Menonaktifkan tombol back
            bottom: const TabBar(
              indicatorColor: Colors.black,
              labelColor: Colors.black, // Warna teks tab yang aktif
              unselectedLabelColor:
                  Colors.grey, // Warna teks tab yang tidak aktif
              tabs: [
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
      int fetchedLevel = levelData['level'];
      expNeeded = levelData['next_level']['exp_needed'];

      double newProgress =
          (totalExp != null && expNeeded != null && expNeeded! > 0)
              ? (totalExp! / expNeeded!).clamp(0.0, 1.0)
              : 0.0;

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQuestHeader(),
            const SizedBox(height: 20),
            _buildInstructionContainer(context),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestHeader() {
    return Shimmer(
      color: const Color(0xFFFFD700),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFB8860B),
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
                              color: Color(0xFFFFD700),
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
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),
          const Text(
            'There are 3 types of quest: easy, medium, hard. When you achieve certain criteria, you will gain a badge.',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),
          const Text(
            'Click the play icon button to start today’s random quest.',
            style: TextStyle(fontSize: 14),
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
                    backgroundColor: const Color(0xFFB8860B),
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

class BadgesTab extends StatelessWidget {
  const BadgesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final List<BadgeItemData> badges = [
      // BadgeItemData(
      //     imagePath: 'assets/badges/badge-1.png',
      //     title: 'Quest Beginner',
      //     subtitle: 'Complete 10 quests'),
      BadgeItemData(
          imagePath: 'assets/badges/badge-2.png',
          title: 'Task Tackler',
          subtitle: 'Complete 50 quests'),
      BadgeItemData(
          imagePath: 'assets/badges/badge-3.png',
          title: 'Mission Veteran',
          subtitle: 'Complete 100 quests'),
      BadgeItemData(
          imagePath: 'assets/badges/badge-1.png',
          title: 'Quest Beginner',
          subtitle: 'Complete 10 quests'),
      BadgeItemData(
          imagePath: 'assets/badges/badge-2.png',
          title: 'Task Tackler',
          subtitle: 'Complete 50 quests'),
      BadgeItemData(
          imagePath: 'assets/badges/badge-3.png',
          title: 'Mission Veteran',
          subtitle: 'Complete 100 quests'),
      BadgeItemData(
          imagePath: 'assets/badges/badge-1.png',
          title: 'Quest Beginner',
          subtitle: 'Complete 10 quests'),
      BadgeItemData(
          imagePath: 'assets/badges/badge-2.png',
          title: 'Task Tackler',
          subtitle: 'Complete 50 quests'),
      BadgeItemData(
          imagePath: 'assets/badges/badge-3.png',
          title: 'Mission Veteran',
          subtitle: 'Complete 100 quests'),
      BadgeItemData(
          imagePath: 'assets/badges/badge-1.png',
          title: 'Quest Beginner',
          subtitle: 'Complete 10 quests'),
      BadgeItemData(
          imagePath: 'assets/badges/badge-2.png',
          title: 'Task Tackler',
          subtitle: 'Complete 50 quests'),
      BadgeItemData(
          imagePath: 'assets/badges/badge-3.png',
          title: 'Mission Veteran',
          subtitle: 'Complete 100 quests'),
      BadgeItemData(
          imagePath: 'assets/badges/badge-1.png',
          title: 'Quest Beginner',
          subtitle: 'Complete 10 quests'),
      BadgeItemData(
          imagePath: 'assets/badges/badge-2.png',
          title: 'Task Tackler',
          subtitle: 'Complete 50 quests'),
      BadgeItemData(
          imagePath: 'assets/badges/badge-10.png',
          title: 'Mission Veteran',
          subtitle: 'Complete 100 quests'),
      BadgeItemData(
          imagePath: 'assets/badges/badge02.png',
          title: 'Mission Veteran',
          subtitle: 'Complete 100 quests'),
    ];

    return Container(
      color: Colors.orange[50], // Warna latar belakang
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 1,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8,
          ),
          itemCount: badges.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Expanded(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        badges[index].imagePath,
                        width: 50,
                        height: 50,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 1),
                SizedBox(
                  width: 200, // Pastikan lebar tetap agar teks tidak melebar
                  child: Text(
                    badges[index].title,
                    textAlign: TextAlign.center,
                    maxLines: 2, // Batasi jumlah baris
                    overflow: TextOverflow
                        .ellipsis, // Tambahkan "..." jika teks kepanjangan
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 1),
                SizedBox(
                  width: 100,
                  child: Text(
                    badges[index].subtitle,
                    textAlign: TextAlign.center,
                    maxLines: 3, // Bisa dua baris jika perlu
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
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
