import 'package:flutter/material.dart';

class DevicePage extends StatelessWidget {
  const DevicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Device", style: TextStyle(foreground: Paint() ..color = Colors.white, fontSize: 25, fontWeight: FontWeight.w900)),
          ]
        )
      ),
    );
  }
}