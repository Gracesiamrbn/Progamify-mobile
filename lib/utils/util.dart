import 'package:flutter_dotenv/flutter_dotenv.dart';

class Util {
  List<Map<String, dynamic>> convertToDynamicMapList(dynamic data) {
    if (data == null) {
      return [];
    }

    if (data is List) {
      return data.map<Map<String, dynamic>>((item) {
        if (item is Map) {
          return Map<String, dynamic>.from(item);
        } else {
          throw FormatException(
              'Expected a List of Maps, but found a List containing non-Map item: $item');
        }
      }).toList();
    } else {
      throw FormatException('Expected a List, but got ${data.runtimeType}');
    }
  }

  String formatDateTime(String inputDateTime) {
    try {
      DateTime dateTime = DateTime.parse(inputDateTime);

      return '${dateTime.day.toString().padLeft(2, '0')}/'
          '${dateTime.month.toString().padLeft(2, '0')}/'
          '${(dateTime.year % 100).toString().padLeft(2, '0')} '
          '${dateTime.hour.toString().padLeft(2, '0')}:'
          '${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return inputDateTime;
    }
  }

  String getLinkLaravel(String link) {
    final String baseUrl =
        dotenv.env["LARAVEL_STORAGE_URL"] ?? "http://10.0.0.2/storage/";

    return "$baseUrl$link";
  }
}
