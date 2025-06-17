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
    bool isSvg = avatarPath.toLowerCase().endsWith('.svg');

    return SliverAppBar(
      expandedHeight: 172.5,
      pinned: true,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          alignment: Alignment.center,
          children: [
            isSvg
                ? SvgPicture.network(
                    avatarPath,
                    fit: BoxFit.cover,
                    placeholderBuilder: (BuildContext context) =>
                        const CircularProgressIndicator(),
                  )
                : Image.network(
                    // Use Image.network for non-SVG network images
                    avatarPath,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.error)),
                  ),
          ],
        ),
      ),
    );
  }
}
