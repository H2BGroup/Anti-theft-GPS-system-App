import 'package:flutter/material.dart';
import 'package:atgs_app/pages/map.dart';
import 'package:atgs_app/pages/profile.dart';
import 'package:atgs_app/pages/device.dart';

const backgroundColor = Color.fromARGB(255, 29, 174, 239);
const darkestBlue = Color.fromARGB(255, 9, 113, 160);
const darkBlue = Color.fromARGB(255, 21, 144, 199);
const lightBlue =Color.fromARGB(255, 151, 222, 254);
const lightGrey = Color.fromARGB(255, 231, 230, 230);

bool deviceArmed = true;
int batteryStatus = 79;
bool signalConnection = false;

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
  static int selectedIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Badge(isLabelVisible: false, child: Icon(Icons.directions_bike, size: 60)),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          widgetOptions.elementAt(selectedIndex),
          Positioned(
            bottom: 0, 
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    height: 35,
                    decoration: const BoxDecoration(color: lightGrey, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                  )
              ]
            )
          )
        ]
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Badge(isLabelVisible: false, child: Icon(Icons.location_pin)),
              label: 'Map'),           
          BottomNavigationBarItem(
              icon: Badge(isLabelVisible: false, child: Icon(Icons.settings)),
              label: 'Device'),
          BottomNavigationBarItem(
              icon: Badge(isLabelVisible: false, child: Icon(Icons.person)),
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
