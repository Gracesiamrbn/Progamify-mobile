import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:progamify/api/auth_service.dart';

class QuestService {
  final String baseUrl =
      dotenv.env["BASE_URL_API"] ?? "http://194.163.40.203:8080/api";
  final AuthService authService = AuthService();

  Future<Map<String, dynamic>> getQuest(int userId) async {
    String? token = await authService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/quest/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load quest data');
    }
  }

  Future<Map<String, dynamic>> submitQuest(
      int id, Map<String, dynamic> jawabanUser) async {
    String? token = await authService.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/quest/submit'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "quest_id": id,
        "answer": convertJawabanUser(jawabanUser),
      }),
    );

    print("Response Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to submit quest answers');
    }
  }

  Map<String, dynamic> convertJawabanUser(Map<String, dynamic> jawabanUser) {
    // Map<String, dynamic> converted = {};
    if (jawabanUser["type"] == "multiple_choice") {
      return {
        "question_id": jawabanUser["question_id"],
        "answer_id": jawabanUser["answer_id"],
        "answer_text": jawabanUser["answer_text"].toString(),
        "index_jawaban": jawabanUser["index_jawaban"],
      };
    } else if (jawabanUser["type"] == "true_false") {
      return {
        "question_id": jawabanUser["question_id"],
        "answer_text": jawabanUser["answer_text"].toString(),
        "index_jawaban": jawabanUser["index_jawaban"],
      };
    } else if (jawabanUser["type"] == "essay" ||
        jawabanUser["type"] == "shortAnswer") {
      return {
        "question_id": jawabanUser["question_id"],
        "index_jawaban": jawabanUser["index_jawaban"].toString(),
      };
    } else if (jawabanUser["type"] == "multiple_answer") {}
    return jawabanUser;
  }

  Future<Map<String, dynamic>> getLevel(int levelId) async {
    String? token = await authService.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/level/$levelId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load level data');
    }
  }
}
