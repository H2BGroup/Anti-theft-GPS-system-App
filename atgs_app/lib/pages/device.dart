import 'dart:async';

import 'package:atgs_app/app.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({super.key});

  @override
  State<DevicePage> createState() => DevicePageState();
}

class DevicePageState extends State<DevicePage> {
  int? batteryPercentage;
  bool? batteryCharging;
  bool? signalConnection;
  DateTime? date;

  void updateStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    if(AppViewState.selectedIndex == 1) {
      await prefs.reload();
      int? battery = prefs.getInt("battery");
      bool? charging = prefs.getBool("charging");
      String? stringDate = prefs.getString("status_utc_time");

      debugPrint("-UPDATE- Battery: $battery");
      debugPrint("-UPDATE- Charging: $charging");
      debugPrint("-UPDATE- Date: $stringDate");

      if (battery != null && charging != null && mounted) {
        setState(() {
          batteryPercentage = battery;
          batteryCharging = charging;
          if(stringDate != null) {
            DateTime parsedDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(stringDate, true).toLocal();
            date = parsedDate;

            DateTime now = DateTime.now();
            Duration difference = now.difference(parsedDate);

            if (difference.inMinutes > 1) {
              signalConnection = false;
            } 
            else {
              signalConnection = true;
            }
          }
        });
      }
    }
  }

  IconData returnBatteryStatusIcon() {
    if(batteryPercentage != null){
      if(batteryCharging != null) {
        if(batteryCharging!) { return Icons.battery_charging_full; }
      }
      if (batteryPercentage == 0) { return Icons.battery_0_bar; } 
      if (batteryPercentage! <= 16) { return Icons.battery_1_bar; }
      if (batteryPercentage! <= 32) { return Icons.battery_2_bar; } 
      if (batteryPercentage! <= 48) { return Icons.battery_3_bar; } 
      if (batteryPercentage! <= 64) { return Icons.battery_4_bar; } 
      if (batteryPercentage! <= 80) { return Icons.battery_5_bar; } 
      if (batteryPercentage! <= 96) { return Icons.battery_6_bar; } 
      else { return Icons.battery_full; }
    }
      else { return Icons.battery_unknown; }
  }

  late Timer timer;
  @override
  void initState() {
    updateStatus();
    timer = Timer.periodic(const Duration(seconds: 10), (t) {
      updateStatus();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 90),
        child: Center(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              constraints: const BoxConstraints(maxHeight: 570),
              width: 330,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(color: darkBlue, borderRadius: BorderRadius.circular(25),border: Border.all(color: darkestBlue, width: 5)),
              child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              
              children: [
                Text("Device status", style: TextStyle(foreground: Paint() ..color = Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
                const SizedBox(height: 45),

                Container(
                  padding: const EdgeInsets.all(10.0),
                  width: 330,
                  decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(25),border: Border.all(color: darkestBlue, width: 3)),
                  child: Column(
                    children: [
                      Text( (deviceArmed) ? "Device: Armed" : "Device: Disarmed", style: TextStyle(foreground: Paint() ..color = Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
                      SizedBox(
                        width: 80,
                        height: 60,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: 
                          Row(children: [
                            Switch(
                              value: deviceArmed,
                              activeColor: darkestBlue,
                              activeTrackColor: darkBlue,
                              inactiveTrackColor: lightBlue,
                              inactiveThumbColor: darkBlue,
                              trackOutlineColor: deviceArmed ? WidgetStateProperty.all(darkestBlue) : WidgetStateProperty.all(darkBlue),
                              onChanged: (bool value) {
                                setState(() { deviceArmed = value;});
                              }
                            )
                          ])
                        )
                      )
                    ],
                  )
                ),
                const SizedBox(height: 45),

                Container(
                  padding: const EdgeInsets.all(15.0),
                  width: 330,
                  decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(25),border: Border.all(color: darkestBlue, width: 3)),
                  child: Column(
                    children: [
                      Text( (batteryPercentage != null) ? "Battery: $batteryPercentage% ${batteryCharging! ? "(Charging)" : ""}" : "Battery: N/A", style: TextStyle(foreground: Paint() ..color = Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
                      Badge(isLabelVisible: false, child: Icon( returnBatteryStatusIcon(), color: darkestBlue, size: 35)),
                    ]
                  )
                ),         
                const SizedBox(height: 45),

                Container(
                  padding: const EdgeInsets.all(15.0),
                  width: 330,
                  decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(25),border: Border.all(color: darkestBlue, width: 3)),
                  child: Column(
                    children: [
                      Text( (signalConnection != null) ? ((signalConnection!) ? "Signal: Connected" : "Signal: Lost connection") : "Signal: N/A", style: TextStyle(foreground: Paint() ..color = Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
                      Badge(isLabelVisible: false, child: Icon( (signalConnection != null) ? ((signalConnection!) ? Icons.signal_cellular_alt_rounded : Icons.signal_cellular_off_rounded) : Icons.signal_cellular_nodata, color: darkestBlue, size: 35)),                  
                    ]
                  )
                )   
              ]
              )
            )
          )
        )
      )
    );
  }
}