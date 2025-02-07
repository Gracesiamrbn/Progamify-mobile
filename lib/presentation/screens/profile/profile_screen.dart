import 'package:flutter/material.dart';
import '../../widgets/profile_header.dart';
import '../../widgets/profile_info.dart';
import '../../widgets/summary_boxes.dart';
import '../../widgets/summary_grid.dart';
import '../../widgets/badges_section.dart';
import '../../widgets/custom_bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FA),
      body: const CustomScrollView(
        slivers: [
          ProfileHeader(
            avatarPath: 'assets/images/avatar_jumbotron.png',
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: 20),
                ProfileInfo(
                  name: "Enrico Sirait",
                  details: "11521034 | email@mail.com | 2021",
                  settingIconPath: "assets/icons/setting_icon.svg",
                  shopIconPath: "assets/icons/shop_icon.svg",
                ),
                SummaryBoxes(),
                SummaryGrid(),
                BadgesSection(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 3,
        onTap: (index) {
          // Handle navigation
        },
      ),
    );
  }
}
