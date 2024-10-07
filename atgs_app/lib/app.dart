import 'dart:async';

import 'package:flutter/material.dart';
import 'package:atgs_app/pages/map.dart';
import 'package:atgs_app/pages/profile.dart';
import 'package:atgs_app/pages/device.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'message_service.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:atgs_app/notifications.dart';

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


void startMessageService(_) {
  receiveMessage();
  sendMessage("location");
  sendMessage("status");
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => AppViewState();
}

class AppViewState extends State<AppView> {
  static int selectedIndex = 0;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  bool lowBatteryNotificationSent = false;
  bool lostSignalNotificationSent = false;
  bool expiringSubscriptionNotificationSent = false;

  Future<void> handleNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  
    await prefs.reload();
    int? battery = prefs.getInt("battery");
    bool? charging = prefs.getBool("charging");
    String? stringDate = prefs.getString("status_utc_time");

    if (battery != null && charging != null) {
      batteryPercentage = battery;
      batteryCharging = charging;
      if (stringDate != null) {
        statusUpdateDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(stringDate, true).toLocal();

        Duration difference = DateTime.now().difference(statusUpdateDate!);

        if (difference.inMinutes > 1) {
          if(!lostSignalNotificationSent) {
            showLostSignalNotification(flutterLocalNotificationsPlugin);
            lostSignalNotificationSent = true;
          }
        } 
        else { lostSignalNotificationSent = false; }
      }

      if (batteryPercentage! < 20 && batteryCharging == false && !lowBatteryNotificationSent) {
        showLowBatteryNotification(flutterLocalNotificationsPlugin);
        lowBatteryNotificationSent = true;
      }
      else if (batteryPercentage! >= 50) { lowBatteryNotificationSent = false; }
    }

    String? savedSubscriptionDate = prefs.getString("selectedDate");
    if(savedSubscriptionDate != null) {
      DateTime subscriptionDate = DateFormat("dd MMMM, yyyy").parse(savedSubscriptionDate, true);
      
        DateTime now = DateTime.now();
        DateTime tomorrow = DateTime(now.year, now.month, now.day + 1);

        bool subscriptionDateIsTomorrow = subscriptionDate.year == tomorrow.year && 
                          subscriptionDate.month == tomorrow.month &&
                          subscriptionDate.day == tomorrow.day;
        
        if(subscriptionDateIsTomorrow && !expiringSubscriptionNotificationSent) {
          showExpiringSubscriptionNotification(flutterLocalNotificationsPlugin);
          expiringSubscriptionNotificationSent = true;
        }
        else if (!subscriptionDateIsTomorrow) { expiringSubscriptionNotificationSent = false; }
    }

    if(movementDetected) {
      showMovementDectectedNotification(flutterLocalNotificationsPlugin);
      movementDetected = false;
    }
  }

  late Timer timer;
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterIsolate.spawn(startMessageService, null);
    initNotifications(flutterLocalNotificationsPlugin);

    timer = Timer.periodic(const Duration(seconds: 20), (t) {
      handleNotifications();
    });
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
          child: Image.asset('assets/logo.png', fit: BoxFit.contain)
        )
      ),
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
              icon: Badge(isLabelVisible: false, child: Icon(Icons.location_pin)),
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
