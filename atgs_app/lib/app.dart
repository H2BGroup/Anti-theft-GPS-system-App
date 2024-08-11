import 'package:flutter/material.dart';
import 'package:atgs_app/pages/map.dart';
import 'package:atgs_app/pages/profile.dart';
import 'package:atgs_app/pages/device.dart';

const backgroundColor = Color.fromARGB(255, 14, 147, 187);

List<Widget> widgetOptions = const <Widget>[
  MapPage(),
  DevicePage(),
  ProfilePage(),
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
