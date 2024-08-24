import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:flutter/material.dart';
import 'package:atgs_app/app.dart';
import 'message_service.dart';

void main() {
  // Start the message service in a separate isolate
  WidgetsFlutterBinding.ensureInitialized();
  FlutterIsolate.spawn(startMessageService, null);

  runApp(const MyApp());
}

void startMessageService(_) {
  message();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
      ),
      home: const AppView(),
    );
  }
}
