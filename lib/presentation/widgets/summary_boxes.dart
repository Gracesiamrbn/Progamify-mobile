import 'package:flutter/material.dart';

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
    final boxItems = items ?? [
      BoxItem(color: Colors.orangeAccent, value: "1", label: "Quest Level"),
      BoxItem(color: Colors.orangeAccent, value: "5", label: "Total XP"),
      BoxItem(color: Colors.orangeAccent, value: "0", label: "Lesson Done"),
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
                    width: 90, 
                    height: 90,
                    decoration: BoxDecoration(
                      color: item.color,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.5),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 6,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        item.value,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4), // Jarak antara box dan judul
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
  final Color color;
  final String value;
  final String label;

  BoxItem({
    required this.color,
    required this.value,
    required this.label,
  });
}
