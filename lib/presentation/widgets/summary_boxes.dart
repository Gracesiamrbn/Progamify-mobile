import 'package:flutter/material.dart';

class SummaryBoxes extends StatelessWidget {
  final List<BoxItem>? items;

  const SummaryBoxes({
    super.key,
    this.items,
  });

  @override
  Widget build(BuildContext context) {
    final boxItems = items ?? [
      BoxItem(color: Colors.amber, value: "100", title: "Points"),
      BoxItem(color: Colors.amber, value: "50", title: "Quests"),
      BoxItem(color: Colors.amber, value: "10", title: "Badges"),
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: boxItems.map((item) {
          return Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: item.color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class BoxItem {
  final Color color;
  final String value;
  final String title;

  BoxItem({
    required this.color,
    required this.value,
    required this.title,
  });
}