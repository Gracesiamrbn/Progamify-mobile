import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:progamify/api/auth_service.dart';

class BadgesService {
  final String baseUrl = dotenv.env["BASE_URL_API"] ?? "http://10.0.0.2/api";
  final AuthService authService = AuthService();

  Future<List<Map<String, dynamic>>> getBadges() async {
    try {
      String? token = await authService.getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/badges'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load badges data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching badges: $e');
    }
  }
}
