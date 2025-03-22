import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:progamify/api/auth_service.dart';

class UserService {
  final String baseUrl =
      dotenv.env["BASE_URL_API"] ?? "http://194.163.40.203:8080/api";
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

  Future<Map<String, dynamic>> changeAvatar(int avatarId) async {
    String? token = await authService.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/users/avatar'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({"avatar_id": avatarId}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to change user's avatar");
    }
  }
}
