import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SummaryBoxes extends StatelessWidget {
  final String title;
  final List<BoxItem>? items;

  const SummaryBoxes({
    super.key,
    this.title = "Boxes",
    this.items,
  });

  @override
  Widget build(BuildContext context) {
    final boxItems = items ??
        [
          BoxItem(
              value: "5",
              label: "experience point",
              icon: "assets/icons/exp_point.png"),
          BoxItem(
              value: "15",
              label: "quest level",
              icon: "assets/icons/treasure.png"),
          BoxItem(
              value: "4", label: "lesson done", icon: "assets/icons/topic.png"),
        ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: boxItems.map((item) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    // height: 100,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB2DAFF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black54),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          item.icon,
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.value,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          item.label,
                          style: const TextStyle(
                            fontSize: 8.5,
                            fontFamily: 'Inter',
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class BoxItem {
  final String value;
  final String label;
  final String icon;

  BoxItem({
    required this.value,
    required this.label,
    required this.icon,
  });
}
