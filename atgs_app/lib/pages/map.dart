import 'package:flutter/material.dart';

const buttonColor = Color.fromARGB(255, 21, 144, 199);

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(20), side: const BorderSide(color: buttonColor, width: 5)),
              onPressed: () {      
                
              },
              child: Text("Show my bike",
                  style: TextStyle(foreground: Paint() ..color = buttonColor, fontSize: 25, fontWeight: FontWeight.w900)),
            ),              
          ]
        )
      ),
    );
  }
}


