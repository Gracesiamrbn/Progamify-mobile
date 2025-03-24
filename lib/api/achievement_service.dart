import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:progamify/api/auth_service.dart';

class AchievementsService {
  final String baseUrl = dotenv.env["BASE_URL_API"] ?? "http://194.163.40.203:8080/api";
  final AuthService authService = AuthService();

  Future<List<Map<String, dynamic>>> getAchievements() async {
    try {
      String? token = await authService.getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/achievements'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load achievements data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching achievements: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAchievementsByUserId(int userId) async {
    try {
      String? token = await authService.getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/achievements/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load achievements data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching achievements: $e');
    }
  }
}
