import 'package:atgs_app/notifications.dart';
import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';

const maxHistoryLength = 120;
const timeDifference = 5;

ConnectionSettings settings = ConnectionSettings(
    host: host,
    virtualHost: user,
    authProvider: PlainAuthenticator(user, rabbitPassword));

void receiveMessage() async {
  Client client = Client(settings: settings);
  Channel channel = await client.channel();
  channel = await channel.qos(0, 1);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? ownersNumber = prefs.getString("ownersNumber");

  if (ownersNumber != null) {
    Queue queue = await channel.queue(ownersNumber, durable: true);
    Consumer consumer = await queue.consume(noAck: false);
    consumer.listen((AmqpMessage message) {
      debugPrint(" [x] Received json: ${message.payloadAsJson}");

      if (message.payloadAsJson['type'] == 'location') {
        if (message.payloadAsJson['latitude'] != null &&
            message.payloadAsJson['longitude'] != null &&
            message.payloadAsJson['utc_time'] != null) {
          double latitude = message.payloadAsJson['latitude'];
          double longitude = message.payloadAsJson['longitude'];
          String dateTime = message.payloadAsJson['utc_time'];

          debugPrint("-RECEIVED- Latitude: $latitude");
          debugPrint("-RECEIVED- Longitude: $longitude");
          debugPrint("-RECEIVED- Date: $dateTime");

          saveLocation(latitude, longitude, dateTime);
        }
      }
      if (message.payloadAsJson['type'] == 'status') {
        if (message.payloadAsJson['percent'] != null &&
            message.payloadAsJson['charging'] != null) {
          int battery = (message.payloadAsJson['percent']).round();
          bool charging = message.payloadAsJson['charging'];
          String dateTime = message.payloadAsJson['utc_time'];

          debugPrint("-RECEIVED- Battery: $battery");
          debugPrint("-RECEIVED- Charging: $charging");
          debugPrint("-RECEIVED- Date: $dateTime");

          saveStatus(battery, charging, dateTime);
        }
      }
      if (message.payloadAsJson['type'] == 'movement_detected') {
        String dateTime = message.payloadAsJson['utc_time'];

        showMovementDectectedNotification(flutterLocalNotificationsPlugin);

        debugPrint("-MOVEMENT DETECTED!- Date: $dateTime");
      }

      message.ack();
    });
  }
}

void sendMessage(dynamic type) async {
  Client client = Client(settings: settings);
  Channel channel = await client.channel();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? deviceNumber = prefs.getString("deviceNumber");

  if (deviceNumber != null) {
    Queue queue = await channel.queue(deviceNumber, durable: true);

    Map<String, dynamic> message;
    if (type == "status" || type == "location") {
      message = {"request": type};
    } else {
      message = {"armed": type};
    }

    queue.publish(message);
    debugPrint("Message: $message");
  }

  channel.close();
  client.close();
}

void saveLocation(double latitude, double longitude, String dateTime) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? stringDate = prefs.getString("history_utc_time");

  await prefs.setDouble("latitude", latitude);
  await prefs.setDouble("longitude", longitude);
  await prefs.setString("utc_time", dateTime);

  DateTime parsedDate =
      DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateTime, true).toLocal();

  if (stringDate != null) {
    DateTime lastDate =
        DateFormat("yyyy-MM-dd HH:mm:ss").parse(stringDate, false);
        
    if (parsedDate.difference(lastDate).inMinutes >= timeDifference) {
      saveLocationAndAdressHistory(latitude, longitude, parsedDate);
    }
  } else {
    saveLocationAndAdressHistory(latitude, longitude, parsedDate);
  }
}

void saveStatus(int battery, bool charging, String dateTime) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt("battery", battery);
  await prefs.setBool("charging", charging);
  await prefs.setString("status_utc_time", dateTime);
}

Future<void> saveLocationAndAdressHistory(
    double latitude, double longitude, DateTime date) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<String>? locationHistory = prefs.getStringList("locationHistory");
  List<String>? addressHistory = prefs.getStringList("addressHistory");

  List<Placemark> placemark =
      await placemarkFromCoordinates(latitude, longitude);

  locationHistory ??= [];
  addressHistory ??= [];

  if (locationHistory.length >= maxHistoryLength) {
    locationHistory.removeAt(0);
    addressHistory.removeAt(0);
  }

  locationHistory.add('$latitude,$longitude');
  addressHistory.add(
      "${placemark[0].street}${placemark[0].locality != "" ? ", ${placemark[0].postalCode} ${placemark[0].locality}" : ""} - ${DateFormat("dd.MM.yyyy HH:mm").format(date)}");

  await prefs.setStringList("locationHistory", locationHistory);
  await prefs.setStringList("addressHistory", addressHistory);
  await prefs.setString("history_utc_time", date.toString());
}
