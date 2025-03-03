import 'package:flutter/material.dart';
import 'package:progamify/api/user_service.dart';
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
  late Future<Map<String, dynamic>> futureUser;

  @override
  void initState() {
    super.initState();
    futureUser = UserService().getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FA),
      body: FutureBuilder<Map<String, dynamic>>(
        future: UserService().getCurrentUser(), // Fetch current user data
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final user = snapshot.data!;
            return CustomScrollView(
              slivers: [
                const ProfileHeader(
                  avatarPath: 'assets/images/avatar_jumbotron.svg',
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      ProfileInfo(
                        name: user['name'], // Use dynamic user name
                        details:
                            "${user['nim']} | ${user['email']} | ${user['angkatan']}",
                        // name: "Boy Martahan Sitorus", // Use dynamic user name
                        // details: "11S21025 | sitorusboy0123@gmail.com | 2021",
                        settingIconPath: "assets/icons/gear.png",
                        shopIconPath: "assets/icons/shopping-cart.png",
                      ),
                      SummaryBoxes(exp: user["total_exp"]),
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
