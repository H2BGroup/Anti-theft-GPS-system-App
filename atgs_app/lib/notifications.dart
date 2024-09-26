import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void initNotifications(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> showLowBatteryNotification(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics = 
    AndroidNotificationDetails(
      'low_battery_channel', 'Low Battery',
      importance: Importance.max, priority: Priority.high, ticker: 'ticker');

  const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0, 'Low Battery', 'Your device battery is below 20%', platformChannelSpecifics);
}

Future<void> showLostSignalNotification(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'lost_signal_channel', 'Lost Signal',
      importance: Importance.max, priority: Priority.high, ticker: 'ticker');

  const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0, 'Lost Signal', 'Lost connection to your device', platformChannelSpecifics);
}

Future<void> showExpiringSubscriptionNotification(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'expiring_subscription_channel', 'Expiring Subscription',
      importance: Importance.max, priority: Priority.high, ticker: 'ticker');

  const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0, 'Expiring Subscription', 'The subscription for your device is expiring tommorow', platformChannelSpecifics);
}

Future<void> showMovementDectectedNotification(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'movement_detected_channel', 'Movement Detected',
      importance: Importance.max, priority: Priority.high, ticker: 'ticker');

  const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0, 'Movement Detected', 'Warning! Your device detected movement', platformChannelSpecifics);
}