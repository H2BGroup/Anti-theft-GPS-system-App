import 'package:flutter/material.dart';
import 'package:atgs_app/app.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(20)),
              onPressed: () {      
                
              },
              child: Text("Show my bike",
                  style: TextStyle(foreground: Paint() ..color = backgroundColor, fontSize: 25, fontWeight: FontWeight.w900)),
            ),
          ]
        )
      ),
    );
  }
}


