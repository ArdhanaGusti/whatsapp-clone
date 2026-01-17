import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_front_end/models/message.dart';
import 'package:mobile_front_end/services/auth_service.dart';
import 'package:mobile_front_end/services/chat_service.dart';
import 'package:mobile_front_end/services/socket_service.dart';
import 'package:mobile_front_end/styles/style.dart';
import 'package:provider/provider.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/custom_text_field.dart';

class ChatRoomPage extends StatefulWidget {
  static const routeName = 'chat_room';
  final int chatId;
  final String title;
  const ChatRoomPage({
    super.key,
    required this.chatId,
    required this.title,
  });

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _controller = TextEditingController();
  
  late StreamSubscription _subscription;
  late final ChatService chatService;
  late final AuthService authService;

  @override
  void initState() {
    chatService = context.read<ChatService>();
    authService = context.read<AuthService>();

    chatService.getMessageDetail(widget.chatId);

    _subscription = SocketService().stream.listen(
      (data) {
        var jsonData = jsonDecode(data);
        var message = Message.fromJson(jsonData);

        if (message.receiverID == authService.profile.id ||
            message.senderId == authService.profile.id) {
          chatService.getMessageDetail(widget.chatId);
          // chatService.getHomeMessage();
        }
        print('Received from: ${message.message}');
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
    _subscription.cancel();
    super.dispose();
  }

  void _sendPressed() {
    SocketService().sendMessage(_controller.text, authService.profile.id, widget.chatId);
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
          alignment: chat.isMe ? Alignment.centerRight : Alignment.centerLeft,
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
