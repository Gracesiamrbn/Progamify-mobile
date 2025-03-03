import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progamify/presentation/screens/auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  final String baseUrl = dotenv.env["BASE_URL_API"] ?? "http://10.0.2.2/api";

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/users/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["user"] != null) {
        print("Raw Response: ${response.body}");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> register(
      String email,
      String password,
      String passwordConfirmation,
      String name,
      int angkatan,
      String nim) async {
    final response = await http.post(
      Uri.parse("$baseUrl/users/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation,
        "name": name,
        "angkatan": angkatan,
        "nim": nim
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["user"] != null) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<void> logout(BuildContext context) async {
    String? token = await getToken();

    if (token != null) {
      final response = await http.delete(Uri.parse("$baseUrl/users/logout"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          });

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');

        // Navigate to the login screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const LoginScreen()), // Replace with your LoginScreen widget
          (Route<dynamic> route) => false, // Remove all previous routes
        );
      } else {}
    }
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    // print("TOKEN USER : $token");
    return token;
  }
}
