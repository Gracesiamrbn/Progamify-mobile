import 'package:flutter/material.dart';
import '../../core/theme/app_styles.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final bool isPassword;
  final VoidCallback? onToggleObscure;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const CustomTextField({
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.isPassword = false,
    this.onToggleObscure,
    this.keyboardType = TextInputType.text,
    this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintStyle: AppStyles.textFieldHintStyle,
        filled: true,
        fillColor: AppStyles.textFieldBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: onToggleObscure,
              )
            : null,
      ),
    );
  }
}
