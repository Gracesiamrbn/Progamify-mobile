import 'package:flutter/material.dart';
import 'package:progamify/presentation/screens/navigation/bottom_navigation.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  void _register() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration Successful!")),
      );
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Sign Up', style: AppStyles.headingStyle),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _passwordController,
                  label: 'Password',
                  obscureText: _isObscure,
                  isPassword: true,
                  onToggleObscure: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
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
                  onToggleObscure: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomButton(onPressed: _register, text: 'Sign Up'),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Already have an account? ',
                        style:
                            TextStyle(color: Colors.black), 
                      ),
                      TextSpan(
                        text: 'Sign In',
                        style: const TextStyle(
                          color: Colors.blue, 
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pop(context); 
                          },
                      ),
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
