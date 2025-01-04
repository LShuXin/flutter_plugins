import 'package:flutter/material.dart';
import 'package:flutter_restart_plus/flutter_restart_plus.dart';

void main() {
  print('app start');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: MaterialButton(
            onPressed: () async {
              final result = await FlutterRestartPlus().restartApp(
                iosNotificationTitle: 'Restart completed',
                iosNotificationContent: 'Tap to open the app'
              );
            },
            color: Colors.blueAccent,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Click me',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 35.0
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
