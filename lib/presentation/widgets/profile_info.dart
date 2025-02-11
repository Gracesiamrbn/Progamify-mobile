import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../screens/profile/setting_screen.dart';
import '../screens/profile/market_screen.dart';

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
            backgroundColor: const Color(0xFFEFEFEF), // Soft Grey
            iconPath: settingIconPath,
            onPressed: () {
              // Navigasi ke halaman SettingsScreen ketika setting diklik
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          _buildIconButton(
            backgroundColor: const Color(0xFFFFF0F2), // Soft Pink
            iconPath: shopIconPath,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MarketScreen(),
                ),
              );
            },
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.white.withOpacity(0.3), // Efek saat ditekan
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color:
                    Colors.black.withOpacity(0.2), // Shadow pertama lebih tajam
                blurRadius: 6,
                offset: const Offset(2, 2),
              ),
              BoxShadow(
                color: Colors.grey.withOpacity(0.3), // Shadow kedua lebih soft
                blurRadius: 12,
                offset: const Offset(4, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: SvgPicture.asset(
            iconPath,
            width: 24,
            height: 24,
          ),
        ),
      ),
    );
  }
}
