import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_front_end/models/chat.dart';
import 'package:mobile_front_end/models/chat_detail.dart';
import '../utils/token_storage.dart';

class ChatService extends ChangeNotifier {
  static const String baseUrl = 'http://10.0.2.2:8080/api/v1/message';
  
  List<Chat> chats = [];
  List<ChatDetail> chatDetails = [];
  bool homeLoading = false;
  bool chatLoading = false;

  Future<void> getHomeMessage() async {
    homeLoading = true;
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

      chats = jsonList
          .map((json) => Chat.fromJson(json))
          .toList();
      homeLoading = false;
      notifyListeners();
    }
  }

  Future<void> getMessageDetail(int chatId) async {
    chatLoading = true;
    final token = await TokenStorage.getToken();

    final resp = await http.get(
      Uri.parse('$baseUrl/detail?userId=$chatId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (resp.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(resp.body);
      
      chatDetails = jsonList
          .map((json) => ChatDetail.fromJson(json))
          .toList();
      chatLoading = false;
      notifyListeners();
    }
  }
}
