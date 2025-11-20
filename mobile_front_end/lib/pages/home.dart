import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_front_end/pages/chat_room.dart';

class HomePage extends StatelessWidget {
  static const routeName = 'home';
  const HomePage({super.key});

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
      itemCount: 8,
      separatorBuilder: (_, __) => const Divider(height: 8),
      itemBuilder: (context, idx) {
        final isMe = idx.isEven;
        return ListTile(
          onTap: () => _openChat(context, 'room_$idx', 'Conversation #$idx'),
          leading: CircleAvatar(child: Text('U$idx')),
          title: Text('User $idx', style: Theme.of(context).textTheme.titleMedium),
          subtitle: Text(isMe ? 'You: That works well.' : 'Hey, what do you think about this design?'),
          trailing: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text('12:3${idx}'), if (idx % 3 == 0) const CircleAvatar(radius: 10, child: Text('3', style: TextStyle(fontSize: 12)))]),
        );
      },
    );

    final body = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: messagesPreview,
    );

    return isIos
        ? CupertinoPageScaffold(navigationBar: appBar as ObstructingPreferredSizeWidget, child: SafeArea(child: body))
        : Scaffold(appBar: appBar as PreferredSizeWidget, body: SafeArea(child: body), floatingActionButton: FloatingActionButton(child: const Icon(Icons.chat), onPressed: () {}));
  }
}
