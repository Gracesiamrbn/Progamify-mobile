import 'package:flutter/material.dart';

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
        appBar: AppBar(
          title: const Text('Quests'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Quests'),
              Tab(text: 'Badges'),
            ],
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

class QuestTab extends StatelessWidget {
  const QuestTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestHeader(),
          const SizedBox(height: 20),
          _buildInstructionContainer(),
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
            child: Column(
              children: const [
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

  Widget _buildInstructionContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
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
            child: FloatingActionButton(
              backgroundColor: Colors.green[800],
              child:
                  const Icon(Icons.play_arrow, color: Colors.white, size: 30),
              onPressed: () {
                // Implement the action for play button
              },
            ),
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
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: const [
        BadgeItem(
            imagePath: 'assets/quest_beginner.png',
            title: 'Quest Beginner',
            subtitle: 'Complete 10 quests'),
        BadgeItem(
            imagePath: 'assets/task_tackler.png',
            title: 'Task Tackler',
            subtitle: 'Complete 50 quests'),
        BadgeItem(
            imagePath: 'assets/mission_veteran.png',
            title: 'Mission Veteran',
            subtitle: 'Complete 100 quests'),
        BadgeItem(
            imagePath: 'assets/starter_badge.png',
            title: 'Starter Badge',
            subtitle: 'Complete an easy quest'),
        BadgeItem(
            imagePath: 'assets/challenger_badge.png',
            title: 'Challenger Badge',
            subtitle: 'Complete a medium quest'),
        BadgeItem(
            imagePath: 'assets/master_badge.png',
            title: 'Master Badge',
            subtitle: 'Complete a hard quest'),
      ],
    );
  }
}

class BadgeItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;

  const BadgeItem(
      {super.key,
      required this.imagePath,
      required this.title,
      required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 9,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                  image: AssetImage('assets/icons/medal1_icon.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
