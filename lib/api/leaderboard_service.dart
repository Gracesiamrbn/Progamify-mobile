import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:progamify/api/auth_service.dart';

class LeaderboardService {
  final String baseUrl = dotenv.env["BASE_URL_API"] ?? "http://10.0.0.2/api";
  final AuthService authService = AuthService();

  Future<List<Map<String, dynamic>>> getLeaderboard() async {
    String? token = await authService.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/leaderboard'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> rawList = json.decode(response.body);
      List<Map<String, dynamic>> leaderboard =
          rawList.cast<Map<String, dynamic>>();

      leaderboard = leaderboard.map((player) {
        player['avatar'] = 'assets/avatars/avatar_male_1.svg';
        return player;
      }).toList();

      return leaderboard;
    } else {
      throw Exception('Failed to load leaderboard data');
    }
  }
}
