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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          
          children: [
            const SizedBox(height: 50),
            Text("Device status", style: TextStyle(foreground: Paint() ..color = Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
            const SizedBox(height: 50),
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
                    activeColor: const Color.fromARGB(255, 9, 113, 160),
                    inactiveTrackColor: const Color.fromARGB(255, 151, 222, 254),
                    inactiveThumbColor: backgroundColor,
                    trackOutlineColor: WidgetStateProperty.all(const Color.fromARGB(255, 9, 113, 160)),
                    onChanged: (bool value) {
                      setState(() { deviceArmed = value;});
                    }
                  ),
                ],)

              ),
            ),
            const SizedBox(height: 20),
            Text("Battery: $batteryStatus%", style: TextStyle(foreground: Paint() ..color = Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
            const SizedBox(height: 50),
            Text( (signalConnection) ? "Signal: Available" : "Signal: Lost connection", style: TextStyle(foreground: Paint() ..color = Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}