import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:progamify/api/auth_service.dart';

class DiscussionService {
  final String baseUrl = dotenv.env["BASE_URL_API"] ?? "http://10.0.0.2/api";
  final AuthService authService = AuthService();

  Future<List<Map<String, String>>> getDiscussions(int lessonId) async {
    String? token = await authService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/discussions/$lessonId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      if (data != null) {
        List<Map<String, String>> discussions = List<Map<String, String>>.from(
          data.map((item) {
            return {
              'id': "${item['id']}",
              'content': item['content'] as String,
              'date': item['date'] as String,
              'name': item['name'] as String,
              'title': item['title'] as String,
            };
          }),
        );
        return discussions;
      }

      return [];
    } else {
      throw Exception('Failed to load discussion data');
    }
  }

  Future<Map<String, dynamic>> submitDiscussion(
      int lessonId, String title, String content) async {
    String? token = await authService.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/discussions'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "lesson_id": lessonId,
        "title": title.toString(),
        "content": content.toString(),
      }),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to submit discussion');
    }
  }
}
