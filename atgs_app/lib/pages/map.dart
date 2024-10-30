import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:atgs_app/message_service.dart';
import 'package:atgs_app/app.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  LatLng mapLatLng = const LatLng(50.22718711817035, 22.91607329997953);
  double mapZoom = 17;
  double mapRotation = 0;
  bool showActualPosition = true;
  bool showPolyline = false;
  DateTime? timeStamp;
  List<String> addressHistory = [];
  List<LatLng> locationHistory = [];

  final MapController mapController = MapController();

  Future<void> showDeviceLocation() async {
    if (!deviceArmed) sendMessage("location");

    mapController.move(mapLatLng, mapZoom);
    mapController.rotate(mapRotation);
  }

  Future<void> loadLocationHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? storedLocationHistory =
        prefs.getStringList("locationHistory");
    List<String>? storedAddressHistory = prefs.getStringList("addressHistory");

    if (storedLocationHistory != null) {
      setState(() {
        locationHistory = storedLocationHistory.map((stringCoords) {
          var coords = stringCoords.split(",");
          return LatLng(double.parse(coords[0]), double.parse(coords[1]));
        }).toList();
      });
    }

    if (storedAddressHistory != null) {
      setState(() {
        addressHistory = storedAddressHistory;
      });
    }
  }

  Future<void> saveLocationHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setStringList("addressHistory", addressHistory);
  }

  void updateLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (AppViewState.selectedIndex == 0) {
      await prefs.reload();
      double? latitude = prefs.getDouble("latitude");
      double? longitude = prefs.getDouble("longitude");
      String? stringDate = prefs.getString("utc_time");

      // debugPrint("-UPDATE- Latitude: $latitude");
      // debugPrint("-UPDATE- Longitude: $longitude");
      // debugPrint("-UPDATE- Date: $stringDate");

      if (latitude != null && longitude != null && mounted) {
        if (mounted) {
          setState(() {
            if (showActualPosition) mapLatLng = LatLng(latitude, longitude);

            if (stringDate != null) {
              timeStamp = DateFormat("yyyy-MM-dd HH:mm:ss")
                  .parse(stringDate, true)
                  .toLocal();
            }
            loadLocationHistory();
          });
        }
        if (showActualPosition && mounted) {
          mapController.move(mapLatLng, mapZoom);
        }
      }
    }
  }

  late Timer timer;
  @override
  void initState() {
    loadLocationHistory();
    updateLocation();
    timer = Timer.periodic(const Duration(seconds: 5), (t) {
      updateLocation();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        minHeight: 65,
        maxHeight: MediaQuery.of(context).size.height * 0.30,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        panel: _buildLocationHistoryPanel(),
        body: Stack(children: [
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
                PolylineLayer(
                  polylines: [
                    if (showPolyline)
                      Polyline(
                        strokeWidth: 4,
                        points: locationHistory,
                        color: Colors.blue,
                      ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: mapLatLng,
                      width: 80,
                      height: 80,
                      builder: (context) {
                        return CustomMarkerWidget(
                          location: mapLatLng,
                          timestamp: timeStamp,
                        );
                      },
                    ),
                  ],
                ),
              ]),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 80),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(20),
                  side: const BorderSide(color: backgroundColor, width: 5),
                ),
                onPressed: () {
                  setState(() {
                    showActualPosition = true;
                    showPolyline = false;
                  });
                  showDeviceLocation();
                },
                child: const Text(
                  "Show my bike",
                  style: TextStyle(
                    color: backgroundColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }

  Widget _buildLocationHistoryPanel() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Location History',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: backgroundColor),
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showPolyline = true;
                      showActualPosition = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: backgroundColor),
                  child: const Text(
                    "Show on map",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16),
                  ))
            ],
          ),
          const Divider(
            color: backgroundColor,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: addressHistory.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading:
                      const Icon(Icons.location_on, color: backgroundColor),
                  title: Text(addressHistory[index],
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  onTap: () {
                    setState(() {
                      showActualPosition = false;
                      mapLatLng = locationHistory[index];
                    });
                    showDeviceLocation();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CustomMarkerWidget extends StatefulWidget {
  const CustomMarkerWidget({
    super.key,
    required this.location,
    required this.timestamp,
  });

  final LatLng location;
  final DateTime? timestamp;

  @override
  State<CustomMarkerWidget> createState() => CustomMarkerWidgetState();
}

class CustomMarkerWidgetState extends State<CustomMarkerWidget> {
  bool showTimestamp = false;
  double timestampBoxOpacity = 0.0;

  onTapMarker() async {
    setState(() {
      showTimestamp = true;
      timestampBoxOpacity = 1.0;
    });

    Timer(const Duration(seconds: 2), () {
      if (AppViewState.selectedIndex == 0) {
        setState(() {
          timestampBoxOpacity = 0.0;
        });
        Timer(const Duration(seconds: 1), () {
          if (AppViewState.selectedIndex == 0) {
            setState(() {
              showTimestamp = false;
            });
          }
        });
      }
    });

    Clipboard.setData(ClipboardData(
        text: "${widget.location.latitude}, ${widget.location.longitude}"));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Coordinates copied to clipboard",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic)),
        duration: Duration(seconds: 1),
        backgroundColor: backgroundColor));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTapMarker,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Center(
            child: Stack(alignment: Alignment.center, children: [
              const Positioned(
                  top: -5,
                  child: Icon(Icons.place, color: backgroundColor, size: 60)),
              Positioned(
                  top: 5,
                  child: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: backgroundColor))),
              const Positioned(
                top: 2,
                child: Icon(
                  Icons.pedal_bike,
                  color: Colors.white,
                  size: 30,
                ),
              )
            ]),
          ),
          if (showTimestamp)
            Positioned(
                bottom: 70,
                child: AnimatedOpacity(
                  duration: const Duration(seconds: 1),
                  opacity: timestampBoxOpacity,
                  child: Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: darkBlue, width: 2),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "${widget.location.latitude}, ${widget.location.longitude}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          widget.timestamp != null
                              ? DateFormat('HH:mm   dd.MM.yyyy')
                                  .format(widget.timestamp!)
                              : "N/A",
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ))
        ],
      ),
    );
  }
}
