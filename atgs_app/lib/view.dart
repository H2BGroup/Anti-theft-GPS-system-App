import 'package:flutter/material.dart';

const backgroundColor = Color.fromARGB(255, 14, 147, 187);

List<Widget> widgetOptions = <Widget>[
    Center(
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
    Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Device", style: TextStyle(foreground: Paint() ..color = Colors.white, fontSize: 25, fontWeight: FontWeight.w900)),
          ]
        )
      ),
    Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Profile", style: TextStyle(foreground: Paint() ..color = Colors.white, fontSize: 25, fontWeight: FontWeight.w900)),
          ]
        )
      ),
  ];

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => AppViewState();
}
class AppViewState extends State<AppView> {
  int selectedIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 14, 147, 187),
        leading: const Badge(child: Icon(Icons.directions_bike, size: 60)),
      ),
      body: Center(
        child: widgetOptions.elementAt(selectedIndex),
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
        unselectedIconTheme: const IconThemeData(color: Colors.grey, size: 32),
        selectedLabelStyle: TextStyle(foreground: Paint() ..color = backgroundColor, fontWeight: FontWeight.w700, fontSize: 15),
        unselectedLabelStyle: TextStyle(foreground: Paint() ..color = Colors.grey, fontWeight: FontWeight.w700, fontSize: 15),

        backgroundColor: Colors.white,
        currentIndex: selectedIndex,
        elevation: 0,
        onTap: (index) => {
          setState(() {selectedIndex = index;})
        },
      ),
    );
  }
}
