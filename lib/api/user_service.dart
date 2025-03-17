import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:progamify/api/auth_service.dart';

class UserService {
  final String baseUrl = dotenv.env["BASE_URL_API"] ?? "http://10.0.0.2/api";
  final AuthService authService = AuthService();

  Future<Map<String, dynamic>> getCurrentUser() async {
    String? token = await authService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/users/current'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load current user data');
    }
  }

  Future<Map<String, dynamic>> getUserById(int userId) async {
    String? token = await authService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load current user data');
    }
  }
}
