import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class SummaryBoxes extends StatefulWidget {
  final String title;
  final List<BoxItem>? items;
  final int exp;
  final int level;
  final int totalLesson;

  const SummaryBoxes({
    super.key,
    this.title = "Boxes",
    required this.exp,
    required this.level,
    this.items,
    required this.totalLesson,
  });

  @override
  _SummaryBoxesState createState() => _SummaryBoxesState();
}

class _SummaryBoxesState extends State<SummaryBoxes> {
  List<bool> isVisibleList = [];

  @override
  void initState() {
    super.initState();
    isVisibleList = List.generate(widget.items?.length ?? 3, (index) => false);
    _startAnimation();
  }

  void _startAnimation() async {
    for (int i = 0; i < isVisibleList.length; i++) {
      await Future.delayed(Duration(milliseconds: i * 300)); // Delay per box
      if (mounted) {
        setState(() {
          isVisibleList[i] = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final boxItems = widget.items ??
        [
          BoxItem(
              value: '${widget.exp}',
              label: "Experience",
              icon: "assets/icons/exp_point.png"),
          BoxItem(
              value: '${widget.level}',
              label: "Level",
              icon: "assets/icons/treasure.png"),
          BoxItem(
              value: "${widget.totalLesson}",
              label: "lesson done",
              icon: "assets/icons/topic.png"),
        ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: boxItems.asMap().entries.map((entry) {
              int index = entry.key;
              BoxItem item = entry.value;

              return AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: isVisibleList[index] ? 1.0 : 0.0,
                child: AnimatedScale(
                  scale: isVisibleList[index] ? 1.0 : 0.8,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutBack,
                  child: Shimmer(
                    duration: const Duration(seconds: 2),
                    color: Colors.white,
                    colorOpacity: 0.3,
                    enabled: true,
                    child: Container(
                      width: 105,
                      height: 105,
                      padding: const EdgeInsets.all(8),
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
                              fontSize: 10,
                              fontFamily: 'Inter',
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
