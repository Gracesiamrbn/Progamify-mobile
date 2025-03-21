import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:progamify/api/auth_service.dart';
import 'package:progamify/utils/util.dart';

class GiftService {
  final String baseUrl = dotenv.env["BASE_URL_API"] ?? "http://10.0.0.2/api";
  final AuthService authService = AuthService();

  Future<List<Map<String, dynamic>>> getGifts() async {
    String? token = await authService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/gifts'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      if (data != null) {
        List<Map<String, dynamic>> gifts = List<Map<String, dynamic>>.from(
          data.map((item) {
            return {
              'id': item['id'],
              'image': Util().getLinkLaravel(item['picture_url'] as String),
              'price': item['price'],
              'name': item['title'] as String,
            };
          }),
        );

        return gifts;
      }

      return [];
    } else {
      throw Exception('Failed to load discussion data');
    }
  }

  Future<Map<String, dynamic>> buyGift(int giftId) async {
    String? token = await authService.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/gifts/buy'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({"gift_id": giftId}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to buy gift");
    }
  }
}
