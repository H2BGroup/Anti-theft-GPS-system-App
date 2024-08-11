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
            const SizedBox(height: 50),
            Text("Profile settings", style: TextStyle(foreground: Paint() ..color = Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
            const SizedBox(height: 50),
            Text( "Device phone number", style: TextStyle(foreground: Paint() ..color = Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
            const SizedBox(height: 50),
            Text( "Subscription expires on", style: TextStyle(foreground: Paint() ..color = Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
           ]
        )
      ),
    );
  }
}