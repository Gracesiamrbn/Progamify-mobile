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
          BoxItem(value: "1", label: "Quest Level"),
          BoxItem(value: "5", label: "Total XP"),
          BoxItem(value: "0", label: "Lesson Done"),
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
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SvgPicture.asset(
                          'assets/stats_container.svg',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(
                        item.value,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 4
                            ..color = const Color(0xFF8B5E3C),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        item.value,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
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

  BoxItem({
    required this.value,
    required this.label,
  });
}
