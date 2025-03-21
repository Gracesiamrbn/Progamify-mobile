import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:progamify/api/user_service.dart';
import 'package:progamify/presentation/screens/navigation/bottom_navigation.dart';

PreferredSizeWidget marketAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.grey),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const MainScreen(currentIndex: 3)),
        );
      },
    ),
    actions: [
      FutureBuilder<Map<String, dynamic>>(
          future: UserService().getCurrentUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final user = snapshot.data!;

              return Row(
                children: [
                  Text(
                    "${user['total_point']}",
                    style: const TextStyle(
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
              );
            }
          }),
    ],
  );
}
