import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileInfo extends StatelessWidget {
  final String name;
  final String details;
  final String settingIconPath;
  final String shopIconPath;

  const ProfileInfo({
    super.key,
    required this.name,
    required this.details,
    required this.settingIconPath,
    required this.shopIconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 4),
                Text(
                  details,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          _buildIconButton(
            backgroundColor: const Color(0xFFD9D9D9),
            iconPath: settingIconPath,
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          _buildIconButton(
            backgroundColor: const Color(0xFFFFE2E5),
            iconPath: shopIconPath,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
  Widget _buildIconButton({
    required Color backgroundColor,
    required String iconPath,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: SvgPicture.asset(iconPath),
        onPressed: onPressed,
        iconSize: 24,
        padding: const EdgeInsets.all(10),
        color: Colors.transparent,
      ),
    );
  }
}
