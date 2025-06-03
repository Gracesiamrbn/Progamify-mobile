import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:progamify/api/auth_service.dart';
import 'package:progamify/utils/util.dart';

class LeaderboardService {
  final String baseUrl =
      dotenv.env["BASE_URL_API"] ?? "http://194.163.40.203:8080/api";
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
          rawList.map<Map<String, dynamic>>((entry) {
        final user = entry['user'];
        final rank = entry['rank'];
        user['avatar'] = Util().getLinkLaravel(user['avatar']['picture_url']);

        return {
          ...user,
          'rank': rank,
        };
      }).toList();

      Logger().i(leaderboard);

      return leaderboard;
    } else {
      throw Exception('Failed to load leaderboard data');
    }
  }
}
