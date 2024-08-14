import 'package:atgs_app/app.dart';
import 'package:flutter/material.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({super.key});

  @override
  State<DevicePage> createState() => DevicePageState();
}

class DevicePageState extends State<DevicePage> {

IconData returnBatteryStatusIcon() {
  if (batteryStatus == 0) {
    return Icons.battery_0_bar;
  } 
  else if (batteryStatus <= 16) {
    return Icons.battery_1_bar;
  } 
  else if (batteryStatus <= 32) {
    return Icons.battery_2_bar;
  } 
  else if (batteryStatus <= 48) {
    return Icons.battery_3_bar;
  } 
  else if (batteryStatus <= 64) {
    return Icons.battery_4_bar;
  } 
  else if (batteryStatus <= 80) {
    return Icons.battery_5_bar;
  } 
  else if (batteryStatus <= 96) {
    return Icons.battery_6_bar;
  } 
  else {
    return Icons.battery_full;
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            margin: const EdgeInsets.only(top: 50),
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
                    Text("Battery: $batteryStatus%", style: TextStyle(foreground: Paint() ..color = Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
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
                    Text( (signalConnection) ? "Signal: Available" : "Signal: Lost connection", style: TextStyle(foreground: Paint() ..color = Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
                    Badge(isLabelVisible: false, child: Icon( signalConnection ? Icons.signal_cellular_alt_rounded : Icons.signal_cellular_off_rounded, color: darkestBlue, size: 35)),                  
                  ]
                )
              )   
            ]
            )
          )
        )
      )
    );
  }
}