import 'package:flutter/material.dart';
import 'package:atgs_app/app.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                center: const LatLng(54.35, 18.61),
                zoom: 18,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                  userAgentPackageName: 'com.example.app',
                ),
              ],
            ),

            Align(
              alignment: Alignment.topCenter, 
              child: Padding(
                padding: const EdgeInsets.only(top: 80),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    side: const BorderSide(color: Colors.blue, width: 5),
                  ),
                  onPressed: () {

                  },
                  child: Text(
                    "Show my bike",
                    style: TextStyle(
                      foreground: Paint()..color = Colors.blue,
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              )
            ),
          ],
        ),
    );
  }
}


