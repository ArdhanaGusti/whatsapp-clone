import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  late final WebSocketChannel _channel;
  late final Stream _broadcastStream;
  bool _isConnected = false;

  Stream<dynamic> get stream => _broadcastStream;

  void connect() {
    if (_isConnected) return;

    _channel = WebSocketChannel.connect(Uri.parse('ws://10.0.2.2:8080/ws'));

    _broadcastStream = _channel.stream.asBroadcastStream();

    _isConnected = true;
  }

  Future<void> sendMessage(String content, int senderId, int receiverID) async {
    final message = {
      "Message": content,
      "SenderID": senderId,
      "ReceiverID": receiverID,
    };

    if (_isConnected) _channel.sink.add(jsonEncode(message));
  }

  void disconnect() {
    _channel.sink.close();
    _isConnected = false;
  }
}
