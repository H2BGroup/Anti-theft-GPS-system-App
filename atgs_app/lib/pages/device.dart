import 'package:flutter/material.dart';

const backgroundColor = Color.fromARGB(255, 14, 147, 187);

class DevicePage extends StatelessWidget {
  const DevicePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 14, 147, 187),
        leading: const Badge(child: Icon(Icons.directions_bike, size: 60)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(20)),
              onPressed: () {      
                
              },
              child: Text("Device",
                  style: TextStyle(foreground: Paint() ..color = backgroundColor, fontSize: 25, fontWeight: FontWeight.w900)),
            ),
          ]
        )
      ),
bottomNavigationBar: BottomNavigationBar(
        items: const [
           BottomNavigationBarItem(
              icon: Badge(child: Icon(Icons.location_pin)),
              label: 'Map'),           
          BottomNavigationBarItem(
              icon: Badge(child: Icon(Icons.settings)),
              label: 'Device'),
          BottomNavigationBarItem(
              icon: Badge(child: Icon(Icons.person)),
              label: 'Profile'),
        ],
        selectedIconTheme: const IconThemeData(color: backgroundColor, size: 32),
      //  selectedItemColor: backgroundColor,
        unselectedIconTheme: const IconThemeData(color: Colors.grey, size: 32),
      //  unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(foreground: Paint() ..color = backgroundColor, fontWeight: FontWeight.w700, fontSize: 15),
        unselectedLabelStyle: TextStyle(foreground: Paint() ..color = Colors.grey, fontWeight: FontWeight.w700, fontSize: 15),

        backgroundColor: Colors.white,
       // elevation: 0,
        onTap: (i) => {
        },
      ),

    );
  }
}
