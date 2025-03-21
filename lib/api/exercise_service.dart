import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:progamify/api/auth_service.dart';

class ExerciseService {
  final String baseUrl = dotenv.env["BASE_URL_API"] ?? "http://194.163.40.203:8080/api";
  final AuthService authService = AuthService();

  Future<Map<String, dynamic>> getExercise(int id) async {
    String? token = await authService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/exercises/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load exercise data');
    }
  }

  Future<Map<String, dynamic>> submitExercise(
    int id,
    Map<int, dynamic> jawabanUser,
  ) async {
    String? token = await authService.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/exercises/submit'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "exercise_id": id,
        "answers": convertJawabanUser(jawabanUser),
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to submit exercise answers');
    }
  }

  Map<String, dynamic> convertJawabanUser(Map<int, dynamic> jawabanUser) {
    Map<String, dynamic> converted = {};
    jawabanUser.forEach((key, value) {
      if (value["type"] == "multiple_choice") {
        converted[key.toString()] = {
          "question_id": value["question_id"],
          "answer_id": value["answer_id"],
          "answer_text": value["answer_text"].toString(),
          "index_jawaban": value["index_jawaban"],
        };
      } else if (value["type"] == "true_false") {
        converted[key.toString()] = {
          "question_id": value["question_id"],
          "answer_text": value["answer_text"].toString(),
          "index_jawaban": value["index_jawaban"],
        };
      } else if (value["type"] == "essay" || value["type"] == "shortAnswer") {
        converted[key.toString()] = {
          "question_id": value["question_id"],
          "index_jawaban": value["index_jawaban"].toString(),
        };
      } else if (value["type"] == "multiple_answer") {
        converted[key.toString()] = {
          "question_id": value["question_id"],
          "answers": value["answers"],
          "index_jawaban": value["index_jawaban"],
        };
      }
    });
    return converted;
  }

  Map<int, dynamic> convertJawabanUserStringToInt(
      Map<String, dynamic> jawabanUser) {
    Map<int, dynamic> intMap =
        jawabanUser.map((key, value) => MapEntry(int.parse(key), value));
    return intMap;
  }
}
