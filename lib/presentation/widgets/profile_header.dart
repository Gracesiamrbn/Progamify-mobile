import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
            SvgPicture.network(
              avatarPath,
              fit: BoxFit.cover,
              placeholderBuilder: (BuildContext context) =>
                  const CircularProgressIndicator(),
            )
            // SvgPicture.asset(
            //   avatarPath,
            //   width: double.infinity,
            //   height: 200,
            //   fit: BoxFit.cover,
            // ),
          ],
        ),
      ),
    );
  }
}
