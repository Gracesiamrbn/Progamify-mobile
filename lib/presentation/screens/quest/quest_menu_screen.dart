import 'package:flutter/material.dart';
import 'package:progamify/presentation/screens/quest/quest_excercise_screen.dart';
import 'package:progamify/api/user_service.dart';

class QuestScreen extends StatefulWidget {
  final int initialTabIndex;
  const QuestScreen({super.key, this.initialTabIndex = 1});

  @override
  QuestScreenState createState() => QuestScreenState();
}

class QuestScreenState extends State<QuestScreen> {
  double progress = 0.5;

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

  @override
  void initState() {
    super.initState();
    _userFuture =
        UserService().getCurrentUser(); // Ambil data user saat pertama kali
    print(_userFuture);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestHeader(),
          const SizedBox(height: 20),
          _buildInstructionContainer(context),
        ],
      ),
    );
  }

  Widget _buildQuestHeader() {
    double progress = 0.5;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[800],
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
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.white54,
                        color: Colors.orange[800],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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
            child: const Column(
              children: [
                Text(
                  'Level',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '4',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
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
              color: Colors.orange[800],
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
                  int userId =
                      snapshot.data!['ID']; // Ambil ID user dari Future

                  return FloatingActionButton(
                    backgroundColor: Colors.green[800],
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
                    width: 120, // Ubah sesuai ukuran yang diinginkan
                    height: 120, // Ukuran seragam
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      // boxShadow: const [
                      //   BoxShadow(
                      //     color: Colors.black26,
                      //     blurRadius: 10,
                      //     offset: Offset(0, 0),
                      //     spreadRadius: 0,
                      //   ),
                      // ],
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
