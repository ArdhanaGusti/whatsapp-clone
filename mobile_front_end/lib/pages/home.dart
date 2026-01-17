import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_front_end/models/chat.dart';
import 'package:mobile_front_end/models/message.dart';
import 'package:mobile_front_end/pages/chat_room.dart';
import 'package:mobile_front_end/services/auth_service.dart';
import 'package:mobile_front_end/services/chat_service.dart';
import 'package:mobile_front_end/services/socket_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const routeName = 'home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late StreamSubscription _subscription;

  late final AuthService authService;
  late final ChatService chatService;
  
  @override
  void initState() {
    authService = context.read<AuthService>();
    chatService = context.read<ChatService>();

    chatService.getHomeMessage();
    authService.getProfile();

    _subscription = SocketService().stream.listen((data) {
        var jsonData = jsonDecode(data);
        var message = Message.fromJson(jsonData);

        if (message.receiverID == authService.profile.id ||
            message.senderId == authService.profile.id) {
          chatService.getHomeMessage();
        }
        print('Received from: ${message.message}');
      },
      onError: (error) {
        print('WebSocket Error: $error');
      },
      onDone: () {
        print('WebSocket closed');
      },);

    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _openChat(BuildContext context, int chatId, int meId, String title) {
    Navigator.of(context).pushNamed(
      ChatRoomPage.routeName,
      arguments: {'chatId': chatId, 'title': title},
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatService = context.watch<ChatService>();
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    final appBar = isIos
        ? CupertinoNavigationBar(
            middle: const Text('Chats'),
            trailing: GestureDetector(
              onTap: () {},
              child: const Icon(CupertinoIcons.pen),
            ),
          )
        : AppBar(
            title: const Text('Chats'),
            actions: [
              IconButton(icon: const Icon(Icons.search), onPressed: () {}),
            ],
          );

    final messagesPreview = ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 12),
      separatorBuilder: (_, __) => const Divider(height: 8),
      itemCount: chatService.chats.length,
      itemBuilder: (context, id) {
        final chat = chatService.chats[id];
        return ListTile(
          onTap: () =>
              _openChat(context, chat.oppositeId, chat.meId, chat.oppositeName),
          leading: CircleAvatar(child: Text('${id + 1}')),
          title: Text(
            chat.oppositeName,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(chat.isSender ? 'You: ${chat.message}' : chat.message),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('12:3${id}'),
              if (id % 3 == 0)
                const CircleAvatar(
                  radius: 10,
                  child: Text('3', style: TextStyle(fontSize: 12)),
                ),
            ],
          ),
        );
      },
    );

    final body = chatService.homeLoading
        ? const Center(child: CircularProgressIndicator())
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: messagesPreview,
          );

    return isIos
        ? CupertinoPageScaffold(
            navigationBar: appBar as ObstructingPreferredSizeWidget,
            child: SafeArea(child: body),
          )
        : Scaffold(
            appBar: appBar as PreferredSizeWidget,
            body: SafeArea(child: body),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.chat),
              onPressed: () {},
            ),
          );
  }
}
