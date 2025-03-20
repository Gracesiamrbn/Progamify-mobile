import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:progamify/api/auth_service.dart';
import 'package:progamify/utils/util.dart';

class AvatarService {
  final String baseUrl = dotenv.env["BASE_URL_API"] ?? "http://10.0.0.2/api";
  final AuthService authService = AuthService();

  Future<List<Map<String, dynamic>>> getAvatars() async {
    String? token = await authService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/avatars'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      if (data != null) {
        List<Map<String, dynamic>> avatars = List<Map<String, dynamic>>.from(
          data.map((item) {
            return {
              'id': item['id'],
              'owned': item['is_locked'] == 0 ? false : true,
              'image': Util().getLinkLaravel(item['picture'] as String),
              'price': item['price'],
              'name': item['title'] as String,
              'selected': false,
            };
          }),
        );
        return avatars;
      }

      return [];
    } else {
      throw Exception('Failed to load discussion data');
    }
  }

  Future<Map<String, dynamic>> buyAvatar(int avatarId) async {
    String? token = await authService.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/avatars/buy'),
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
}
