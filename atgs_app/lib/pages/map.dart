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
  LatLng mapLatLng = const LatLng(40.712776, -74.005974);
  double mapZoom = 18;

  final MapController mapController = MapController();

  void showDeviceLocation() {
    setState(() {
      mapLatLng = const LatLng(40.712776, -74.005974);
      mapZoom = 18;
    });
    mapController.move(mapLatLng, mapZoom);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                center: mapLatLng,
                zoom: mapZoom,
                maxZoom: 18,
                minZoom: 11,
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
                    side: const BorderSide(color: backgroundColor, width: 5),
                  ),
                  onPressed: showDeviceLocation,
                  child: Text(
                    "Show my bike",
                    style: TextStyle(
                      foreground: Paint()..color = backgroundColor,
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


