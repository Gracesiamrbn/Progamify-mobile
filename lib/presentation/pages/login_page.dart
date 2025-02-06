import 'package:flutter/material.dart';
import '../widgets/text_field_style1.dart';
import '../widgets/button_style1.dart';
import 'package:progamify/core/theme/app_styles.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  void _login() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login successful!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sign In', style: AppStyles.headingStyle),
                const SizedBox(height: 20),
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
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomButton(onPressed: _login, text: 'Login'),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {},
                  child: const Text('Don’t have an account? Sign up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}