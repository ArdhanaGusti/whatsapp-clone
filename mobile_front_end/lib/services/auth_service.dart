import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/token_storage.dart';

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/v1/auth';

  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];

      await TokenStorage.saveToken(token);
      return true;
    } else {
      return false;
    }
  }

  static Future<http.Response> getProfile() async {
    final token = await TokenStorage.getToken();

    return await http.get(
      Uri.parse('$baseUrl/me'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }
}
