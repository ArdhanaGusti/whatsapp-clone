// import 'package:flutter/material.dart';
// import 'package:web_socket_channel/io.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final channel = IOWebSocketChannel.connect('ws://10.0.2.2:8080/ws?id=39');

//   @override
//   void dispose() {
//     channel.sink.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             channel.sink.add('Hello back server!');
//           },
//           child: Icon(Icons.send),
//         ),
//         appBar: AppBar(
//           title: Text('WebSocket Example'),
//         ),
//         body: StreamBuilder(
//           stream: channel.stream,
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               return Center(
//                 child: Text('Received: ${snapshot.data}'),
//               );
//             } else {
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
