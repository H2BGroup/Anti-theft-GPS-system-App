import 'package:flutter/material.dart';
import 'package:atgs_app/app.dart';

void main() {
  runApp(const MyApp());
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