import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:progamify/api/auth_service.dart';

class ExerciseService {
  final String baseUrl =
      dotenv.env["BASE_URL_API"] ?? "http://194.163.40.203:8080/api";
  final AuthService authService = AuthService();

  Future<Map<String, dynamic>> getExercise(int id, {bool all = false}) async {
    String? token = await authService.getToken();
    final String url = all ? '$baseUrl/exercises/$id?all=true' : '$baseUrl/exercises/$id';
    final response = await http.get(
      Uri.parse(url),
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
      final String? type = value["type"] as String?;

      switch (type) {
        case "multiple_choice":
          converted[key.toString()] = {
            "question_id": value["question_id"],
            "answer_id": value["answer_id"],
            "answer_text": value["answer_text"]?.toString() ?? "",
            "index_jawaban": value["index_jawaban"],
          };
          break;
        case "true_false":
          converted[key.toString()] = {
            "question_id": value["question_id"],
            "answer_text": value["answer_text"]?.toString() ?? "",
            "index_jawaban": value["index_jawaban"],
          };
          break;
        case "essay":
        case "short_answer":
          // both essay and short_answer use the same backend field
          converted[key.toString()] = {
            "question_id": value["question_id"],
            // server expects the written text for open questions
            "answer_text": value["answer_text"]?.toString() ?? "",
          };
          break;
        case "multiple_answer":
          converted[key.toString()] = {
            "question_id": value["question_id"],
            "answers": value["answers"],
            "index_jawaban": value["index_jawaban"],
          };
          break;
        case "matching":
          converted[key.toString()] = {
            "question_id": value["question_id"],
            "answers": value["answers"],
            "index_jawaban": value["index_jawaban"] ?? 0,
          };
          break;
        default:
          // unknown type, ignore
          break;
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
