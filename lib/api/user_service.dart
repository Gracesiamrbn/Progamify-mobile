import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:progamify/api/auth_service.dart';

class UserService {
  final String baseUrl = "http://10.0.2.2:8080/api";
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
}
