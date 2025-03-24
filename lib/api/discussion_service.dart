import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:progamify/api/auth_service.dart';
import 'package:progamify/utils/util.dart';

class DiscussionService {
  final String baseUrl =
      dotenv.env["BASE_URL_API"] ?? "http://194.163.40.203:8080/api";
  final AuthService authService = AuthService();

  Future<List<Map<String, String>>> getDiscussions(int lessonId) async {
    String? token = await authService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/discussions/lesson/$lessonId'),
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
              'id': "${item['ID']}",
              'content': item['content'] as String,
              'date': Util().formatDateTime(item['CreatedAt']),
              'name': item['user']['name'] as String,
              'title': item['title'] as String,
              'replies': "${item['replies'].length}",
              'picture':
                  Util().getLinkLaravel(item['user']['avatar']['picture_url'])
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

  Future<Map<String, dynamic>> detailDiscussion(int discussionId) async {
    String? token = await authService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/discussions/$discussionId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      Logger().i(data);
      return data;
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

  Future<Map<String, dynamic>> submitReply(
      int discussionId, String content) async {
    String? token = await authService.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/discussions/reply'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "discussion_id": discussionId,
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
