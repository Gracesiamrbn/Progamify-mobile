import 'package:flutter/material.dart';

class AppStyles {
  // Text Styles

  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    fontFamily: 'Inter',
  );

  static const TextStyle titleStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    fontFamily: 'Inter',
  );

  static const TextStyle cardTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: 'Inter',
  );

  static const TextStyle captionStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: 'Inter',
    color: Colors.grey,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    fontFamily: 'Inter',
    letterSpacing: 1.2,
  );

  static const TextStyle highlightStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    fontFamily: 'Inter',
    color: Colors.blueAccent,
  );

  static const TextStyle instructionStyle = TextStyle(
    fontSize: 14,
    fontFamily: 'Inter',
    color: Colors.white,
  );

  static const TextStyle cardDescriptionStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    fontFamily: 'Inter',
    color: Colors.black,
  );

  static const TextStyle topicTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    fontFamily: 'Inter',
    color: Colors.black,
  );

  // Section Label
  static const TextStyle topicSectionStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    fontFamily: 'Inter',
    color: Colors.black87,
  );

  static const TextStyle errorStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: 'Inter',
    color: Colors.red,
  );

  static const TextStyle successStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: 'Inter',
    color: Colors.green,
  );

  static const TextStyle boldWhite = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Button Styles

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

  // Text Field Styles

  static const Color textFieldBackground = Color(0xFFD9D9D9);

  static const TextStyle textFieldHintStyle = TextStyle(
    color: Color(0xFF8F9098),
    fontSize: 16,
    fontFamily: 'Inter',
  );

  // Progress Text
  static const TextStyle sectionProgressStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );
}
