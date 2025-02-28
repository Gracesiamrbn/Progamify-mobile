import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MarketSelectedItem extends StatelessWidget {
  final int selectedIndex;
  final int selectedTabIndex;

  const MarketSelectedItem({
    super.key,
    required this.selectedIndex,
    required this.selectedTabIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      width: double.infinity,
      height: 175,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: selectedTabIndex == 0
            ? SvgPicture.asset(
                "assets/avatars/avatar_jumbotron_${selectedIndex + 1}.svg",
                fit: BoxFit.contain,
                placeholderBuilder: (context) =>
                    const Center(child: CircularProgressIndicator()),
              )
            : Image.asset(
                "assets/gifts/gift_${selectedIndex + 1}.png",
                fit: BoxFit.contain,
              ),
      ),
    );
  }
}
