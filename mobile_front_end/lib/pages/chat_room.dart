import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_front_end/models/chat_detail.dart';
import 'package:mobile_front_end/models/message.dart';
import 'package:mobile_front_end/services/chat_service.dart';
import 'package:mobile_front_end/services/socket_service.dart';
import 'package:mobile_front_end/styles/style.dart';
import 'package:provider/provider.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/custom_text_field.dart';

class ChatRoomPage extends StatefulWidget {
  static const routeName = 'chat_room';
  final int chatId;
  final int meId;
  final String title;
  const ChatRoomPage({super.key, required this.chatId, required this.meId ,required this.title});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _controller = TextEditingController();
  final socketService = SocketService();

  @override
  void initState() {
    context.read<ChatService>().getMessageDetail(widget.chatId);

    socketService.connect();
    
    socketService.stream.listen(
      (data) {
        var jsonData = jsonDecode(data);
        var message = Message.fromJson(jsonData);
        
        context.read<ChatService>().getMessageDetail(widget.chatId);
        context.read<ChatService>().getHomeMessage();
        // if (message) {
          
        // }
        print('Received from WS: ${message.message}');
      },
      onError: (error) {
        print('WebSocket Error: $error');
      },
      onDone: () {
        print('WebSocket closed');
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    socketService.disconnect();
    super.dispose();
  }

  void _sendPressed() {
    socketService.sendMessage(_controller.text, widget.meId, widget.chatId);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final chatService = context.watch<ChatService>();
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;

    final appBar = isIos
        ? CupertinoNavigationBar(
            middle: Text(widget.title),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(CupertinoIcons.phone),
                SizedBox(width: 8),
                Icon(CupertinoIcons.video_camera),
              ],
            ),
          )
        : AppBar(
            title: Text(widget.title),
            actions: [
              IconButton(icon: const Icon(Icons.call), onPressed: () {}),
              IconButton(icon: const Icon(Icons.videocam), onPressed: () {}),
            ],
          );

    // final messages = List.generate(
    //   8,
    //   (i) => {'me': i % 2 == 0, 'text': 'Message #$i'},
    // );

    final messageList = ListView.builder(
      reverse: true,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      itemCount: chatService.chatDetails.length,
      itemBuilder: (context, id) {
        final chat = chatService.chatDetails[id];
        return Align(
          alignment: chat.isMe
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: ChatBubble(
              text: chat.message,
              isMe: chat.isMe,
              time: '12:${10 + id}',
            ),
          ),
        );
      },
    );

    final inputBar = SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _controller,
                hintText: 'Type a message',
                maxLines: 1,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.emoji_emotions_outlined),
                  onPressed: () {},
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Send button
            GestureDetector(
              onTap: _sendPressed,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );

    final scaffoldBody = chatService.chatLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Expanded(child: messageList),
              inputBar,
            ],
          );

    return isIos
        ? CupertinoPageScaffold(
            navigationBar: appBar as ObstructingPreferredSizeWidget,
            child: scaffoldBody,
          )
        : Scaffold(appBar: appBar as PreferredSizeWidget, body: scaffoldBody);
  }
}
