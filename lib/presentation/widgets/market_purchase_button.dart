import 'package:flutter/material.dart';

class MarketPurchaseButton extends StatelessWidget {
  final int selectedIndex;

  const MarketPurchaseButton({
    super.key,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: selectedIndex >= 0 ? () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Item purchased!")),
            );
          } : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedIndex >= 0 ? Colors.orange : Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "Purchase",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
