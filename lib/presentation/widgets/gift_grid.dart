import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GiftGrid extends StatelessWidget {
  final int selectedGiftIndex;
  final Function(int) onGiftSelect;

  const GiftGrid({super.key, required this.selectedGiftIndex, required this.onGiftSelect});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onGiftSelect(index),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: selectedGiftIndex == index ? Colors.blue : Colors.grey[300]!,
                        width: selectedGiftIndex == index ? 2 : 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: SvgPicture.asset(
                        "assets/gifts/gift_${index + 1}.svg",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${(index + 1) * 10}k",
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
