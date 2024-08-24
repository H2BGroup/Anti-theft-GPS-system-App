import 'package:flutter/material.dart';
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
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(40.712776, -74.005974),
                    width: 80,
                    height: 80,
                    builder: (context) {
                      return Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(
                              Icons.place,
                              color: Colors.blue,
                              size: 60,
                            ),
                            Positioned(
                              top: 10,
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            const Positioned(
                              top: 7,
                              child: Icon(
                                Icons.pedal_bike,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
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
                onPressed: showDeviceLocation,
                child: const Text(
                  "Show my bike",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
