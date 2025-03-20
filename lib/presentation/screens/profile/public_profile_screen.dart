import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import '../../widgets/profile_info.dart';
import '../../widgets/summary_boxes.dart';
import '../../widgets/summary_grid.dart';
import '../../widgets/badges_section.dart';

class PublicProfileScreen extends StatelessWidget {
  final Map<String, dynamic> user;

  const PublicProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    Logger().i(user);
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color(0xFF4285F4),
            elevation: 2,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text(
              'Profile',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter'),
            ),
            // centerTitle: true,
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Center(
              child: Hero(
                tag: user['name'],
                child: SvgPicture.network(
                  user['avatar'],
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 20),
                ProfileInfo(
                  name: user['name'],
                  details:
                      "${user['nim']} | ${user['email']} | ${user['angkatan']}",
                ),
                SummaryBoxes(
                  exp: user['total_exp'],
                  level: user['level_id'],
                  totalLesson: 0,
                ),
                const SummaryGrid(),
                const BadgesSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
