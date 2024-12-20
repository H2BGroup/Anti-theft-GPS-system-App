import 'package:flutter/material.dart';
import 'package:atgs_app/pages/map.dart';
import 'package:atgs_app/pages/profile.dart';
import 'package:atgs_app/pages/device.dart';

const backgroundColor = Color.fromARGB(255, 29, 174, 239);
const darkestBlue = Color.fromARGB(255, 9, 113, 160);
const darkBlue = Color.fromARGB(255, 21, 144, 199);
const lightBlue = Color.fromARGB(255, 151, 222, 254);
const lightGrey = Color.fromARGB(255, 231, 230, 230);
const introductionDark = Color.fromARGB(255, 0, 105, 152);
const introductionLight = Color.fromARGB(255, 179, 208, 241);

bool deviceArmed = true;
bool movementDetected = false;

int? batteryPercentage;
bool? batteryCharging;
bool? signalConnection;
DateTime? statusUpdateDate;

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
              alignment: Alignment.centerLeft,
              child: Image.asset('assets/logo.png', fit: BoxFit.contain))),
      extendBodyBehindAppBar: true,
      body: Stack(children: [
        widgetOptions.elementAt(selectedIndex),
        const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
            ))
      ]),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon:
                  Badge(isLabelVisible: false, child: Icon(Icons.location_pin)),
              label: 'Map'),
          BottomNavigationBarItem(
              icon: Badge(isLabelVisible: false, child: Icon(Icons.settings)),
              label: 'Device'),
          BottomNavigationBarItem(
              icon: Badge(isLabelVisible: false, child: Icon(Icons.person)),
              label: 'Profile'),
        ],
        selectedIconTheme:
            const IconThemeData(color: backgroundColor, size: 32),
        unselectedIconTheme: const IconThemeData(color: Colors.grey, size: 32),
        selectedLabelStyle: TextStyle(
            foreground: Paint()..color = backgroundColor,
            fontWeight: FontWeight.w700,
            fontSize: 15),
        unselectedLabelStyle: TextStyle(
            foreground: Paint()..color = Colors.grey,
            fontWeight: FontWeight.w700,
            fontSize: 15),
        backgroundColor: Colors.white,
        currentIndex: selectedIndex,
        elevation: 0,
        onTap: (index) => {
          setState(() {
            selectedIndex = index;
          })
        },
      ),
    );
  }
}
