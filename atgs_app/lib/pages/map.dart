import 'package:flutter/material.dart';

const backgroundColor = Color.fromARGB(255, 14, 147, 187);

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:
            const Text("ATGS", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 14, 147, 187),
      //  leading: Image.asset('assets/icons/placeholder.png'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
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
