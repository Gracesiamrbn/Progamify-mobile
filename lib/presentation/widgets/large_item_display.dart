import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LargeItemDisplay extends StatelessWidget {
  final int selectedItemIndex;
  final bool isGift;

  const LargeItemDisplay({super.key, required this.selectedItemIndex, required this.isGift});

  @override
  Widget build(BuildContext context) {
    String imagePath = isGift
        ? "assets/gifts/gift_${selectedItemIndex + 1}.svg"
        : "assets/avatars/avatar_jumbotron_${selectedItemIndex + 1}.svg";

    String itemName = isGift ? "pulsa" : "Avatar ${selectedItemIndex + 1}";
    String price = isGift ? "Rp100.000" : "${(selectedItemIndex + 1) * 10}k";

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.black),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SvgPicture.asset(
                imagePath,
                fit: BoxFit.contain,
                placeholderBuilder: (context) => const CircularProgressIndicator(),
              ),
            ),
          ),
          Text(itemName, style: const TextStyle(color: Colors.white, fontSize: 16)),
          Text(price, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
