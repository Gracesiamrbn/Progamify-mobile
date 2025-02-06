import 'package:flutter/material.dart';

class AppStyles {
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    fontFamily: 'Inter',
  );

  static final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 16),
    textStyle: const TextStyle(fontSize: 18, fontFamily: 'Inter'),
  );

  static final ButtonStyle buttonPrimaryStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF4285F4), // Warna tombol #4285F4
    padding: const EdgeInsets.symmetric(vertical: 16), // Padding vertikal
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8), // Sudut membulat
    ),
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    fontFamily: 'Inter',
  );

  static const Color textFieldBackground = Color(0xFFD9D9D9);
  static const TextStyle textFieldHintStyle = TextStyle(
    color: Color(0xFF8F9098), // Placeholder
    fontSize: 16,
    fontFamily: 'Inter',
  );
}
