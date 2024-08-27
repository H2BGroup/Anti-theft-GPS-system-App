import "package:atgs_app/pages/profile.dart";
import "package:dart_amqp/dart_amqp.dart";
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
  String? ownersNumber = prefs.getString(ProfilePageState.ownersNumberKey);

  if (ownersNumber != null) {
    Queue queue = await channel.queue(ownersNumber, durable: true);
    Consumer consumer = await queue.consume();
    consumer.listen((AmqpMessage message) {
      print(" [x] Received json: ${message.payloadAsJson}");

      if (message.payloadAsJson['type'] == 'location') {
        if (message.payloadAsJson['latitude'] != null && message.payloadAsJson['longitude'] != null) {
          double latitude = double.parse(message.payloadAsJson['latitude']);
          double longitude = double.parse(message.payloadAsJson['longitude']);
          String dateTime = message.payloadAsJson['utc_time'];
          print("latitude $latitude");
          print("longitude $longitude");
          print("date $dateTime");

          saveLocation(latitude, longitude, dateTime);
        }
      }
      else if (message.payloadAsJson['type'] == 'status') {
        if (message.payloadAsJson['battery'] != null) {}
      }
    });
  }
}

void sendMessage(String type) async {
  Client client = Client(settings: settings);
  Channel channel = await client.channel();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? deviceNumber = prefs.getString(ProfilePageState.deviceNumberKey);

    if (deviceNumber != null) { 
      Queue queue = await channel.queue(deviceNumber, durable: true);

      Map<String, String> message = {"request": type};
      queue.publish(message);
      print("Message: $message");
    }
}

void saveLocation(double latitude, double longitude, String dateTime) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setDouble("latitude", latitude);
  await prefs.setDouble("longitude", longitude);
  await prefs.setString("utc_time", dateTime);
}
