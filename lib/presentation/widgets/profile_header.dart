import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String avatarPath;

  const ProfileHeader({
    super.key,
    required this.avatarPath,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 172.5,
      pinned: true,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(avatarPath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
