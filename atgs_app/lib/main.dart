import 'package:flutter/material.dart';
import 'package:atgs_app/pages/map.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
            theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
      ),
      home: const MapPage(),
    );
  }
}