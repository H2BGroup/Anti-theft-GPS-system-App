import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:atgs_app/app.dart';

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
            const SizedBox(height: 80),
            Text( "Device phone number", style: TextStyle(foreground: Paint() ..color = Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
            SizedBox(
              width: 250,
              height: 75,
              child: 
                TextField(
                  style: TextStyle(fontWeight: FontWeight.w700, foreground: Paint() ..color = Colors.white, fontSize: 20),
                  cursorColor: darkestBlue,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                  ],
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: darkestBlue, width: 2.0)),
                    focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: darkestBlue, width: 2.0)),
                    hintText: deviceNumber,
                    hintStyle: TextStyle(fontWeight: FontWeight.w700, foreground: Paint() ..color = Colors.white, fontSize: 20)
                  ),
                  maxLength: 9,
                ),
              ),
            const SizedBox(height: 80),
            Text( "Subscription expires on", style: TextStyle(foreground: Paint() ..color = Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
           ]
        )
      ),
    );
  }
}