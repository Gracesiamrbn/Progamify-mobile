import 'package:flutter/material.dart';
import 'package:progamify/presentation/screens/navigation/bottom_navigation.dart';
import '../../widgets/text_field_style1.dart';
import '../../widgets/button_style1.dart';
import '../../../core/theme/app_styles.dart';
import 'package:progamify/api/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    // _checkLogin();
  }

  Future<void> _checkLogin() async {
    String? token = await _authService.getToken();
    if (token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  Future<void> _login() async {
    bool success = await _authService.login(
        _emailController.text, _passwordController.text);

    if (success) {
      await _authService.getToken();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login successful!")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Failed, Email or Password Wrong!")),
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
                const Text('Sign In', style: AppStyles.headingStyle),
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
                CustomButton(onPressed: _login, text: 'Sign In'),
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
