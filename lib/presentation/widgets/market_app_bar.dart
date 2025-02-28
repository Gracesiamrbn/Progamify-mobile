import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

PreferredSizeWidget marketAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.grey),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    actions: [
      Row(
        children: [
          const Text(
            '512',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 6),
          SvgPicture.asset(
            "assets/icons/coin.svg",
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 16),
        ],
      ),
    ],
  );
}
