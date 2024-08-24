import "package:dart_amqp/dart_amqp.dart";
import "package:shared_preferences/shared_preferences.dart";
import "config.dart";

ConnectionSettings settings = ConnectionSettings(
    host: host,
    virtualHost: user,
    authProvider: PlainAuthenticator(user, rabbitPassword));

void message() async {
  Client client = Client(settings: settings);

  Channel channel = await client.channel();
  Queue queue = await channel.queue(queueName, durable: true);
  Consumer consumer = await queue.consume();
  consumer.listen((AmqpMessage message) {
    print(" [x] Received json: ${message.payloadAsJson}");

    double latitude = double.parse(message.payloadAsJson['latitude']);
    double longitude = double.parse(message.payloadAsJson['longitude']);
    print("latitude $latitude");
    print("longitude $longitude");

    saveLocation(latitude, longitude);
  });
}

void saveLocation(double latitude, double longitude) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setDouble("latitude", latitude);
  await prefs.setDouble("longitude", longitude);
}
