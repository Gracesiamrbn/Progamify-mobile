import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MarketSelectedItem extends StatelessWidget {
  final int selectedIndex;
  final int selectedTabIndex;
  final dynamic selectedItem;

  const MarketSelectedItem(
      {super.key,
      required this.selectedIndex,
      required this.selectedTabIndex,
      required this.selectedItem});

  @override
  Widget build(BuildContext context) {
    bool isSvg = selectedItem["image"].toLowerCase().endsWith('.svg');
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      width: double.infinity,
      height: 175,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: isSvg
            ? SvgPicture.network(
                selectedItem["image"] ?? "",
                fit: BoxFit.contain,
                placeholderBuilder: (context) =>
                    const Center(child: CircularProgressIndicator()),
              )
            : Image.network(
                selectedItem["image"] ?? "",
                fit: BoxFit.contain,
              ),
      ),
    );
  }
}
