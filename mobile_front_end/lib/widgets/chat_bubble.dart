import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final String? time;
  final bool isMe;
  final double radius;
  const ChatBubble({super.key, required this.text, this.time, this.isMe = false, this.radius = 16});

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? Theme.of(context).colorScheme.primary : Theme.of(context).cardColor;
    final textColor = isMe ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color;
    final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final borderRadius = BorderRadius.only(
      topLeft: Radius.circular(radius),
      topRight: Radius.circular(radius),
      bottomLeft: Radius.circular(isMe ? radius : 4),
      bottomRight: Radius.circular(isMe ? 4 : radius),
    );

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: align,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: borderRadius,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 4))],
            ),
            child: Text(text, style: TextStyle(color: textColor, fontSize: 15)),
          ),
          if (time != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(time!, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11)),
            ),
        ],
      ),
    );
  }
}
