import 'package:flutter/material.dart';
import 'package:progamify/api/user_service.dart';
import 'package:progamify/utils/util.dart';
import '../../widgets/profile_header.dart';
import '../../widgets/profile_info.dart';
import '../../widgets/summary_boxes.dart';
import '../../widgets/summary_grid.dart';
import '../../widgets/badges_section.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Map<String, dynamic>> _futureUser;

  @override
  void initState() {
    super.initState();
    _futureUser = UserService().getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FA),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final user = snapshot.data!;

            final avatarLink = Util().getLinkLaravel(user["detail_avatar"]
                    ["picture_url"] ??
                'assets/images/avatar_jumbotron.svg');

            return CustomScrollView(
              slivers: [
                ProfileHeader(
                  avatarPath: avatarLink,
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      ProfileInfo(
                        name: user['name'],
                        details:
                            "${user['nim']} | ${user['email']} | ${user['angkatan']}",
                        settingIconPath: "assets/icons/gear.png",
                        shopIconPath: "assets/icons/shopping-cart.png",
                      ),
                      SummaryBoxes(
                        exp: user["total_exp"],
                        level: user["level_id"],
                        totalLesson: user["total_lesson_taken"],
                      ),
                      const SummaryGrid(),
                      const BadgesSection(),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
