import 'package:flutter/material.dart';

class MarketTabSelector extends StatelessWidget {
  final int selectedTabIndex;
  final ValueChanged<int> onTabSelected;

  const MarketTabSelector({
    super.key,
    required this.selectedTabIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildTab("Avatar", 0),
          _buildTab("Gift", 1),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(index),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            decoration: BoxDecoration(
              color: selectedTabIndex == index ? Colors.white : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
