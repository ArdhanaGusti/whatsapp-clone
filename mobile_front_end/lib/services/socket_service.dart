import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketService {
  late WebSocketChannel channel;

  Stream<dynamic> get stream => channel.stream;

  void connect() {
    channel = WebSocketChannel.connect(
      Uri.parse('ws://10.0.2.2:8080/ws'),
    );
  }

  Future<void> sendMessage(String content, int senderId, int receiverID) async {
    final message = {
      "Message": content,
      "SenderID": senderId,
      "ReceiverID": receiverID,
    };

    channel.sink.add(jsonEncode(message));
  }

  void disconnect() {
    channel.sink.close();
  }
}
