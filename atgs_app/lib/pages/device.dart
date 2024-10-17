import 'dart:async';
import 'dart:math';
import 'package:atgs_app/app.dart';
import 'package:atgs_app/message_service.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({super.key});

  @override
  State<DevicePage> createState() => DevicePageState();
}

class DevicePageState extends State<DevicePage> with SingleTickerProviderStateMixin {

  late AnimationController refreshButtonController;
  static ValueNotifier<bool> stopRefreshingAnimationNotifier = ValueNotifier<bool>(false);

  void saveDeviceArmedStatus(bool armed) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("deviceArmedKey", armed);
    await HomeWidget.updateWidget(name: 'RemoteWidgetProvider');
  }

  void loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? armed = prefs.getBool("deviceArmedKey");

    if (armed != null) { setState(() {deviceArmed = armed; }); }
  }

  void updateStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(AppViewState.selectedIndex == 1) {
      await prefs.reload();
      int? battery = prefs.getInt("battery");
      bool? charging = prefs.getBool("charging");
      String? stringDate = prefs.getString("status_utc_time");

      // debugPrint("-UPDATE- Battery: $battery");
      // debugPrint("-UPDATE- Charging: $charging");
      // debugPrint("-UPDATE- Date: $stringDate");

      if (battery != null && charging != null && mounted) {
        setState(() {
          batteryPercentage = battery;
          batteryCharging = charging;
          if(stringDate != null) {
            statusUpdateDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(stringDate, true).toLocal();

            DateTime now = DateTime.now();
            Duration difference = now.difference(statusUpdateDate!);

            if (difference.inMinutes > 1) {
              signalConnection = false;
            } 
            else {
              signalConnection = true;
              stopRefreshingAnimationNotifier.value = true;
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

void refreshDeviceStatus() {
  if (!mounted || refreshButtonController.isAnimating) return; 

  sendMessage("status");
  if (AppViewState.selectedIndex == 1 && mounted) {
    stopRefreshingAnimationNotifier.value = false;
    refreshButtonController.repeat();
    stopRefreshingAnimationNotifier.addListener(() {
      if (stopRefreshingAnimationNotifier.value && mounted) { refreshButtonController.stop(); }
    });
  }
}

@override
void didChangeDependencies() {
  super.didChangeDependencies();
  if (mounted && ModalRoute.of(context)?.isCurrent == false) { refreshButtonController.stop(); }
}

  @override
  void dispose() {
    refreshButtonController.dispose();
    timer.cancel();
    super.dispose();
  }

  late Timer timer;
  @override
  void initState() {
    updateStatus();
    loadSavedData();
    timer = Timer.periodic(const Duration(seconds: 10), (t) {
      updateStatus();
    });
    if(AppViewState.selectedIndex == 1 && mounted){
      refreshButtonController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    }
    else {
    refreshButtonController = AnimationController.unbounded(vsync: this);
    }
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
                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(8.0),
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
                                setState(() {
                                  deviceArmed = value;
                                  sendMessage(deviceArmed);
                                  saveDeviceArmedStatus(deviceArmed);
                                });
                              }
                            )
                          ])
                        )
                      )
                    ],
                  )
                ),
                const SizedBox(height: 25),

                Container(
                  padding: const EdgeInsets.all(8.0),
                  width: 330,
                  decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(25),border: Border.all(color: darkestBlue, width: 3)),
                  child: Column(
                    children: [
                      Text( (batteryPercentage != null) ? "Battery: $batteryPercentage% ${batteryCharging! ? "(Charging)" : ""}" : "Battery: N/A", style: TextStyle(foreground: Paint() ..color = Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
                      Badge(
                        isLabelVisible: false,
                        child: Icon( returnBatteryStatusIcon(),
                          color: darkestBlue,
                          size: 45
                        )
                      ),
                      Text( (signalConnection != null) ? ((signalConnection!) ? "" : "Last update: ${DateFormat('dd.MM.yyyy, HH:mm').format(statusUpdateDate!)}") : "", style: TextStyle(foreground: Paint() ..color = Colors.white, fontSize: 16, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic))
                    ]
                  )
                ),         
                const SizedBox(height: 25),

                Container(
                  padding: const EdgeInsets.all(8.0),
                  width: 330,
                  decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(25),border: Border.all(color: darkestBlue, width: 3)),
                  child: Column(
                    children: [
                      Text( (signalConnection != null) ? ((signalConnection!) ? "Signal: Connected" : "Signal: Lost connection") : "Signal: N/A", style: TextStyle(foreground: Paint() ..color = Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
                      Badge(
                        isLabelVisible: false, 
                        child: Icon( (signalConnection != null) ? ((signalConnection!) ? Icons.signal_cellular_alt_rounded : Icons.signal_cellular_off_rounded) : Icons.signal_cellular_nodata, 
                          color: (signalConnection != null) ? ((signalConnection!) ? darkestBlue : Colors.red) : Colors.orange, 
                          size: 45
                        )
                      )                  
                    ]
                  )
                ),
                const SizedBox(height: 15),

                Container(
                  padding: const EdgeInsets.all(2.0),
                  width: 80,
                  decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(25),border: Border.all(color: darkestBlue, width: 3)),
                  child: GestureDetector(
                    onTap: refreshDeviceStatus,
                    child: AnimatedBuilder(
                      animation: refreshButtonController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: refreshButtonController.value * 2.0 * pi,
                          child: child,
                        );
                      },
                      child: const Icon(Icons.refresh_rounded, color: darkestBlue,  size: 50)
                    )
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