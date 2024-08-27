import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:atgs_app/message_service.dart';
import 'package:atgs_app/app.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  LatLng mapLatLng = const LatLng(50.22718711817035, 22.91607329997953);
  double mapZoom = 17;
  double mapRotation = 0;
  bool initial = true;
  bool showTimestamp = false;
  DateTime? date;

  final MapController mapController = MapController();

  void showDeviceLocation() {
    sendMessage("location");
    mapController.move(mapLatLng, mapZoom);
    mapController.rotate(mapRotation);
  }

  void updateLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    if(AppViewState.selectedIndex == 0) {
      await prefs.reload();
      double? latitude = prefs.getDouble("latitude");
      double? longitude = prefs.getDouble("longitude");
      String? stringDate = prefs.getString("utc_time");

      print(latitude);
      print(longitude);
      if (latitude != null && longitude != null && mounted) {
        setState(() {
          mapLatLng = LatLng(latitude, longitude);

          if(stringDate != null) {
            DateTime parsedDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(stringDate, true).toLocal();
            date = parsedDate;
          }
        });
      }
      if (initial) {
        mapController.move(mapLatLng, mapZoom);
        initial = false;
      }
    }
  }

  onTapMarker ({required BuildContext context}) async {
    setState(() {
      showTimestamp = true;
    });

    Timer(const Duration(seconds: 3), () {
      setState(() {
        showTimestamp = false;
      });
    });
  }

  late Timer timer;
  @override
  void initState() {
    updateLocation();
    timer = Timer.periodic(const Duration(seconds: 3), (t) {
      updateLocation();
    });
    super.initState();
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
                    point: mapLatLng,
                    width: 80,
                    height: 80,
                    builder: (context) {
                      return GestureDetector(
                        onTap: () => onTapMarker(context: context),
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            Center(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  const Icon(
                                    Icons.place,
                                    color: backgroundColor,
                                    size: 60
                                  ),
                                  Positioned(
                                    top: 10,
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: backgroundColor
                                      )
                                    )
                                  ),
                                  const Positioned(
                                    top: 7,
                                    child: Icon(
                                      Icons.pedal_bike,
                                      color: Colors.white,
                                      size: 30,
                                    )
                                  )
                                ]
                              )
                            ),
                            if (showTimestamp) 
                              Positioned(
                                bottom: 70,
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(10.0), border: Border.all(color: darkBlue, width: 2)),
                                  child: Column(
                                    children: [
                                      Text("${mapLatLng.latitude}, ${mapLatLng.longitude}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
                                      Text(DateFormat('HH:mm   dd.MM.yyyy').format(date!), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic)),
                                  ],) 
                                  
                                )
                              ),
                          ]
                        )
                      );
                    }
                  )
                ]
              )
            ]
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
                child: const Text(
                  "Show my bike",
                  style: TextStyle(
                    color: backgroundColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  )
                )
              )
            )
          )
        ]
      )
    );
  }
}
