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

  Future<Map<String, dynamic>> changePassword(
      String password, String newPassword, String newPasswordConfirm) async {
    // Cek apakah password baru dan konfirmasi password cocok
    if (newPassword != newPasswordConfirm) {
      throw Exception("New password and confirmation do not match.");
    }

    String? token = await authService.getToken();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/password'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "password": password,
          "new_password": newPassword,
          "new_password_confirmation": newPasswordConfirm,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        var errorResponse = json.decode(response.body);
        throw Exception(errorResponse['error'] ?? 'Unknown error');
      }
    } catch (e) {
      // Tangani kesalahan jaringan atau kesalahan lain
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> updateUser(
      String name, String nim, int angkatan) async {
    String? token = await authService.getToken();

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/users/current'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "name": name,
          "nim": nim,
          "angkatan": angkatan,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        var errorResponse = json.decode(response.body);
        throw Exception(errorResponse['error'] ?? 'Unknown error');
      }
    } catch (e) {
      // Tangani kesalahan jaringan atau kesalahan lain
      throw Exception(e);
    }
  }

  Future<Map<String, int>> getUserTotalLesson(int userId) async {
    String? token = await authService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/users/totalLesson/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data != null) {
        Map<String, int> totalLesson = {
          "total_lesson_taken": data["total_lesson_taken"]
        };
        return totalLesson;
      }

      return {"total_lesson_taken": 0};
    } else {
      throw Exception('Failed to get user total lesson taken');
    }
  }
}
