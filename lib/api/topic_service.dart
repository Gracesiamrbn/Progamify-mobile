import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:progamify/api/auth_service.dart';

class TopicService {
  final String baseUrl = dotenv.env["BASE_URL_API"] ?? "http://194.163.40.203:8080/api";
  final AuthService authService = AuthService();

  Future<List<Map<String, dynamic>>> listTopics() async {
    String? token = await authService.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/topics'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load topic data');
    }
  }

  Future<Map<String, dynamic>> getTopic(int id) async {
    String? token = await authService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/topics/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load topic data');
    }
  }
}
