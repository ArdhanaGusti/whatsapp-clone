import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_front_end/models/chat.dart';
import '../utils/token_storage.dart';

class ChatService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/v1/message';

  static Future<List<Chat>> getHomeMessage() async {
    final token = await TokenStorage.getToken();

    final resp = await http.get(
      Uri.parse('$baseUrl/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (resp.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(resp.body);
      
      print(jsonList
          .map((json) => Chat.fromJson(json))
          .toList());
      return jsonList
          .map((json) => Chat.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load profile');
    }
  }
}
