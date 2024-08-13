import 'package:atgs_app/app.dart';
import 'package:flutter/material.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({super.key});

  @override
  State<DevicePage> createState() => DevicePageState();
}

class DevicePageState extends State<DevicePage> {

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
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(color: darkBlue, borderRadius: BorderRadius.circular(25),border: Border.all(color: darkestBlue, width: 5)),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            
            children: [
              Text("Device status", style: TextStyle(foreground: Paint() ..color = Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
              const SizedBox(height: 80),
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
              ),
              const SizedBox(height: 60),
              Text("Battery: $batteryStatus%", style: TextStyle(foreground: Paint() ..color = Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
              const SizedBox(height: 100),
              Text( (signalConnection) ? "Signal: Available" : "Signal: Lost connection", style: TextStyle(foreground: Paint() ..color = Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
            ]
          )
          )
        )
      )
    );
  }
}