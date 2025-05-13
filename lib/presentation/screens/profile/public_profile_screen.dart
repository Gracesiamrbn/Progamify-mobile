import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:progamify/api/user_service.dart';
import '../../widgets/profile_info.dart';
import '../../widgets/public_badges_section.dart';
import '../../widgets/summary_boxes.dart';
import '../../widgets/public_summary_grid.dart';

class PublicProfileScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const PublicProfileScreen({super.key, required this.user});

  @override
  PublicProfileScreenState createState() => PublicProfileScreenState();
}

class PublicProfileScreenState extends State<PublicProfileScreen> {
  @override
  Widget build(BuildContext context) {
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
            title: Text(
              widget.user['name'],
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter'),
            ),
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Center(
              child: Hero(
                tag: widget.user['name'],
                child: SvgPicture.network(
                  widget.user['avatar'],
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
                  name: widget.user['name'],
                  details:
                      "${widget.user['nim']} | ${widget.user['email']} | ${widget.user['angkatan']}",
                ),
                FutureBuilder<Map<String, int>>(
                    future: UserService().getUserTotalLesson(widget.user["ID"]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        final totalLessonData =
                            snapshot.data!["total_lesson_taken"];
                        return SummaryBoxes(
                          exp: widget.user['total_exp'],
                          level: widget.user['level_id'],
                          totalLesson: totalLessonData ?? 0,
                        );
                      }
                    }),
                PublicSummaryGrid(
                  userId: widget.user['ID'],
                ),
                PublicBadgesSection(userId: widget.user['ID']),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
