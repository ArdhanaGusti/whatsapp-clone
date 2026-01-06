import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_front_end/styles/style.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/custom_text_field.dart';

class ChatRoomPage extends StatefulWidget {
  static const routeName = 'chat_room';
  final String roomId;
  final String title;
  const ChatRoomPage({super.key, required this.roomId, required this.title});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _controller = TextEditingController();

  void _sendPressed() {
    // UI-only: clear input
    _controller.clear();
    // Would append new message to list in functional app
  }

  @override
  Widget build(BuildContext context) {
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;

    final appBar = isIos
        ? CupertinoNavigationBar(
            middle: Text(widget.title),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: const [Icon(CupertinoIcons.phone), SizedBox(width: 8), Icon(CupertinoIcons.video_camera)]),
          )
        : AppBar(title: Text(widget.title), actions: [IconButton(icon: const Icon(Icons.call), onPressed: () {}), IconButton(icon: const Icon(Icons.videocam), onPressed: () {})]);

    // Mock messages (UI only)
    final messages = List.generate(8, (i) => {'me': i % 2 == 0, 'text': 'Message #$i'});

    final messageList = ListView.builder(
      reverse: true,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final item = messages[index];
        return Align(
          alignment: item['me'] == 1 ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: ChatBubble(
              text: item['text'] as String,
              isMe: item['me'] as bool,
              time: '12:${10 + index}',
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
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, -2))],
        ),
        child: Row(children: [
          Expanded(
            child: CustomTextField(
              controller: _controller,
              hintText: 'Type a message',
              maxLines: 1,
              suffixIcon: IconButton(icon: const Icon(Icons.emoji_emotions_outlined), onPressed: () {}),
            ),
          ),
          const SizedBox(width: 8),
          // Send button
          GestureDetector(
            onTap: _sendPressed,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              child: const Icon(Icons.send, color: Colors.white, size: 18),
            ),
          )
        ]),
      ),
    );

    final scaffoldBody = Column(children: [
      Expanded(child: messageList),
      inputBar,
    ]);

    return isIos
        ? CupertinoPageScaffold(navigationBar: appBar as ObstructingPreferredSizeWidget, child: scaffoldBody)
        : Scaffold(appBar: appBar as PreferredSizeWidget, body: scaffoldBody);
  }
}
