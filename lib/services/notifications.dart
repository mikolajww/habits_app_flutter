
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notifications {

  static FlutterLocalNotificationsPlugin plugin;
  static const String channelId = '123456';
  static const String channelName = 'Habitect';
  static const String channelDescription = 'Habitect - app for building habits';

  static init() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: selectNotification);
    plugin = flutterLocalNotificationsPlugin;
  }

  static Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
  }

  static sendNotification(String title, String body, {String payload}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channelId, channelName, channelDescription,
      sound: RawResourceAndroidNotificationSound("gadugadu"),
      playSound: true,
      importance: Importance.max, priority: Priority.high, showWhen: true);
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await plugin.show(0, 'Workout', 'time for the gainz', platformChannelSpecifics, payload: 'item x');
  }

}