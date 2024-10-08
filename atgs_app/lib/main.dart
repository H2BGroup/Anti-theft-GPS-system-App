import 'package:flutter/material.dart';
import 'package:atgs_app/app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:atgs_app/pages/introduction.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    checkifInitialized();
  }

  Future<void> checkifInitialized() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? savedisInitialized = prefs.getBool("isInitialized");

    if(savedisInitialized != null) {
      setState(() {
        isInitialized = savedisInitialized;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData( 
        scaffoldBackgroundColor: backgroundColor,
        textSelectionTheme: const TextSelectionThemeData(selectionHandleColor: darkestBlue)
      ),
      home: (isInitialized) ? const AppView() : const IntroductionView()
    );
  }
}
