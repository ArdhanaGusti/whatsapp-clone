import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_front_end/models/chat.dart';
import 'package:mobile_front_end/pages/chat_room.dart';
import 'package:mobile_front_end/services/chat_service.dart';

class HomePage extends StatefulWidget {
  static const routeName = 'home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  List<Chat> chats = [];

  @override
  void initState() {
    super.initState();
    _fetchChat();
  }

  Future<void> _fetchChat() async {
    try {
      final result = await ChatService.getHomeMessage();
      setState(() {
        chats = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Get Data Failed')),
      );
    }
  }

  void _openChat(BuildContext context, String roomId, String title) {
    Navigator.of(context).pushNamed(ChatRoomPage.routeName, arguments: {'roomId': roomId, 'title': title});
  }

  @override
  Widget build(BuildContext context) {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    final appBar = isIos
        ? CupertinoNavigationBar(middle: const Text('Chats'), trailing: GestureDetector(onTap: () {}, child: const Icon(CupertinoIcons.pen)))
        : AppBar(title: const Text('Chats'), actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})]);

    final messagesPreview = ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 12),
      separatorBuilder: (_, __) => const Divider(height: 8),
      itemCount: chats.length,
      itemBuilder: (context, id) {
        final chat = chats[id];
        final isMe = chat.isSender;
        return ListTile(
          onTap: () => _openChat(context, 'room_$id', 'Conversation #$id'),
          leading: CircleAvatar(child: Text('${id + 1}')),
          title: Text(chat.oppositeName, style: Theme.of(context).textTheme.titleMedium),
          subtitle: Text(isMe ? 'You: ${chat.message}' : chat.message),
          trailing: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text('12:3${id}'), if (id % 3 == 0) const CircleAvatar(radius: 10, child: Text('3', style: TextStyle(fontSize: 12)))]),
        );
      },
    );

    final body = isLoading ? const Center(child: CircularProgressIndicator()) : Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: messagesPreview,
    );

    return isIos
        ? CupertinoPageScaffold(navigationBar: appBar as ObstructingPreferredSizeWidget, child: SafeArea(child: body))
        : Scaffold(appBar: appBar as PreferredSizeWidget, body: SafeArea(child: body), floatingActionButton: FloatingActionButton(child: const Icon(Icons.chat), onPressed: () {}));
  }
}
