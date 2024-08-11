import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Profile", style: TextStyle(foreground: Paint() ..color = Colors.white, fontSize: 25, fontWeight: FontWeight.w900)),
          ]
        )
      ),
    );
  }
}