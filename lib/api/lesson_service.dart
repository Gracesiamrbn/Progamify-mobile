import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:progamify/api/auth_service.dart';

class LessonService {
  final String baseUrl = "http://10.0.2.2:8080/api";
  final AuthService authService = AuthService();

  Future<Map<String, dynamic>> getLesson(int id) async {
    String? token = await authService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/lessons/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load lesson data');
    }
  }
}
