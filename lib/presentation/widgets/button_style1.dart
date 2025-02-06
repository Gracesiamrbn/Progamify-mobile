import 'package:flutter/material.dart';
import 'package:progamify/core/theme/app_styles.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const CustomButton({
    required this.onPressed,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: AppStyles.buttonStyle,
        child: Text(text, style: AppStyles.buttonTextStyle),
      ),
    );
  }
}
