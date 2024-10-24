import 'dart:async';
import 'dart:ui';

import 'package:atgs_app/message_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notifications.dart';

bool lowBatteryNotificationSent = false;
bool lostSignalNotificationSent = false;
bool expiringSubscriptionNotificationSent = false;

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      initialNotificationTitle: 'BACKGROUND SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  startMessageService(null);

  Timer.periodic(const Duration(seconds: 20), (t) {
    handleNotifications();
  });
}

bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

void startMessageService(_) {
  receiveMessage();
  sendMessage("location");
  sendMessage("status");
}

Future<void> handleNotifications() async {
  int? batteryPercentage;
  bool? batteryCharging;
  DateTime? statusUpdateDate;

  SharedPreferences prefs = await SharedPreferences
      .getInstance(); // lost signal and low battery notifications

  await prefs.reload();
  int? battery = prefs.getInt("battery");
  bool? charging = prefs.getBool("charging");
  String? stringDate = prefs.getString("status_utc_time");

  if (battery != null && charging != null) {
    batteryPercentage = battery;
    batteryCharging = charging;
    if (stringDate != null) {
      statusUpdateDate =
          DateFormat("yyyy-MM-dd HH:mm:ss").parse(stringDate, true).toLocal();

      Duration difference = DateTime.now().difference(statusUpdateDate);

      if (difference.inMinutes > 1) {
        if (!lostSignalNotificationSent) {
          showLostSignalNotification(flutterLocalNotificationsPlugin);
          lostSignalNotificationSent = true;
        }
      } else {
        lostSignalNotificationSent = false;
      }
    }

    if (batteryPercentage < 20 &&
        batteryCharging == false &&
        !lowBatteryNotificationSent) {
      showLowBatteryNotification(flutterLocalNotificationsPlugin);
      lowBatteryNotificationSent = true;
    } else if (batteryPercentage >= 50) {
      lowBatteryNotificationSent = false;
    }
  }

  String? savedSubscriptionDate =
      prefs.getString("selectedDate"); // expiring subscription notification

  if (savedSubscriptionDate != null) {
    DateTime subscriptionDate =
        DateFormat("dd MMMM, yyyy").parse(savedSubscriptionDate, true);

    DateTime tomorrow = DateTime.now().add(const Duration(days: 1));

    bool subscriptionDateIsTomorrow = subscriptionDate.year == tomorrow.year &&
        subscriptionDate.month == tomorrow.month &&
        subscriptionDate.day == tomorrow.day;

    if (subscriptionDateIsTomorrow && !expiringSubscriptionNotificationSent) {
      showExpiringSubscriptionNotification(flutterLocalNotificationsPlugin);
      expiringSubscriptionNotificationSent = true;
    } else if (!subscriptionDateIsTomorrow) {
      expiringSubscriptionNotificationSent = false;
    }
  }
}
