import "package:atgs_app/app.dart";
import "package:dart_amqp/dart_amqp.dart";
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import "config.dart";

ConnectionSettings settings = ConnectionSettings(
    host: host,
    virtualHost: user,
    authProvider: PlainAuthenticator(user, rabbitPassword));

void receiveMessage() async {
  Client client = Client(settings: settings);
  Channel channel = await client.channel();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? ownersNumber = prefs.getString("ownersNumber");

  if (ownersNumber != null) {
    Queue queue = await channel.queue(ownersNumber, durable: true);
    Consumer consumer = await queue.consume();
    consumer.listen((AmqpMessage message) {
      debugPrint(" [x] Received json: ${message.payloadAsJson}");

      if (message.payloadAsJson['type'] == 'location') {
        if (message.payloadAsJson['latitude'] != null && message.payloadAsJson['longitude'] != null && message.payloadAsJson['utc_time'] != null) {
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
        if (message.payloadAsJson['percent'] != null && message.payloadAsJson['charging'] != null) {
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
        movementDetected = true;
        String dateTime = message.payloadAsJson['utc_time'];

        debugPrint("-MOVEMENT DETECTED!- Date: $dateTime");
      }
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
      if(type == "status" || type == "location") { message = {"request": type}; }
      
      else { message = {"armed": type}; }
      
      queue.publish(message);
      debugPrint("Message: $message");
    }
}

void saveLocation(double latitude, double longitude, String dateTime) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setDouble("latitude", latitude);
  await prefs.setDouble("longitude", longitude);
  await prefs.setString("utc_time", dateTime);
}

void saveStatus(int battery, bool charging, String dateTime) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt("battery", battery);
  await prefs.setBool("charging", charging);
  await prefs.setString("status_utc_time", dateTime);
}
