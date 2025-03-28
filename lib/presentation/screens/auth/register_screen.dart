import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progamify/presentation/screens/navigation/bottom_navigation.dart';
import '../../../api/auth_service.dart';
import '../../widgets/text_field_style1.dart';
import '../../widgets/button_style1.dart';
import '../../../core/theme/app_styles.dart';
import 'package:flutter/gestures.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _angkatanController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  bool _isLoading = false;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      int? angkatan = int.tryParse(_angkatanController.text);
      if (angkatan == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid angkatan format")),
        );
        setState(() => _isLoading = false);
        return;
      }

      String? errorMessage = await AuthService().register(
        _emailController.text,
        _passwordController.text,
        _confirmPasswordController.text,
        _nameController.text,
        angkatan,
        _nimController.text,
        1,
      );

      setState(() => _isLoading = false);

      if (errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration Successful!")),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RegisterScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/logo.png',
                    height: 150,
                  ),
                ),
                const Center(
                  child: Text('Sign Up', style: AppStyles.headingStyle),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _nameController,
                        label: 'Full Name',
                        keyboardType: TextInputType.name,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter your full name'
                            : null,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _emailController,
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter your email'
                            : null,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _angkatanController,
                        label: 'Angkatan',
                        keyboardType: TextInputType.number,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter your angkatan'
                            : null,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _nimController,
                        label: 'NIM',
                        keyboardType: TextInputType.text,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter your NIM'
                            : null,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _passwordController,
                        label: 'Password',
                        obscureText: _isObscure,
                        isPassword: true,
                        onToggleObscure: () =>
                            setState(() => _isObscure = !_isObscure),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          if (!RegExp(r'[A-Z]').hasMatch(value)) {
                            return 'Password must contain at least one uppercase letter';
                          }
                          if (!RegExp(r'[a-z]').hasMatch(value)) {
                            return 'Password must contain at least one lowercase letter';
                          }
                          if (!RegExp(r'[0-9]').hasMatch(value)) {
                            return 'Password must contain at least one number';
                          }
                          if (!RegExp(r'[\p{S}\p{P}]', unicode: true)
                              .hasMatch(value)) {
                            return 'Password must contain at least one special character';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _confirmPasswordController,
                        label: 'Confirm Password',
                        obscureText: _isObscure,
                        isPassword: true,
                        onToggleObscure: () =>
                            setState(() => _isObscure = !_isObscure),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Please confirm your password';
                          if (value != _passwordController.text)
                            return 'Passwords do not match';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : CustomButton(onPressed: _register, text: 'Sign Up'),
                      const SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Already have an account? ',
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text: 'Sign In',
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
