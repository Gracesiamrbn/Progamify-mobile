import 'package:flutter/material.dart';

class Leaderboard extends StatelessWidget {
  final List<Map<String, dynamic>> leaderboard;

  const Leaderboard({super.key, required this.leaderboard});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        _buildTopThree(),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: leaderboard.length,
            itemBuilder: (context, index) {
              final user = leaderboard[index];
              return _buildLeaderboardTile(user, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTopThree() {
    return Column(
      children: [
        const Text(
          'Leaderboard',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTopAvatar('assets/silver.png', 'Jane Doe'),
            const SizedBox(width: 20),
            _buildTopAvatar('assets/gold.png', 'John Doe', isWinner: true),
            const SizedBox(width: 20),
            _buildTopAvatar('assets/bronze.png', 'James Doe'),
          ],
        ),
      ],
    );
  }

  Widget _buildTopAvatar(String image, String name, {bool isWinner = false}) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: isWinner ? Border.all(color: Colors.amber, width: 2) : null,
          ),
          child: Image.asset(image, fit: BoxFit.cover),
        ),
        const SizedBox(height: 5),
        Text(name,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildLeaderboardTile(Map<String, dynamic> user, int index) {
    Color bgColor;
    TextStyle rankStyle;

    switch (index) {
      case 0:
        bgColor = Colors.yellow.shade700;
        rankStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
        break;
      case 1:
        bgColor = Colors.grey.shade300;
        rankStyle = const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue);
        break;
      case 2:
        bgColor = Colors.brown.shade400;
        rankStyle = const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red);
        break;
      default:
        bgColor = index % 2 == 0 ? Colors.brown.shade100 : Colors.white;
        rankStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      color: bgColor,
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text('#${index + 1}', style: rankStyle),
          ),
          const SizedBox(width: 20),
          CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            radius: 18,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              user['name'],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            '${user['xp']} XP',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
