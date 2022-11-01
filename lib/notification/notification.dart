import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:todo_list/model/todo.dart';
// import 'package:timezone/data/latest.dart' as tz;
class NotificationServer{

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static Future initialize() async {
    var androidInitialize = new AndroidInitializationSettings('mipmap/ic_launcher');
    var iOSInitialize = new DarwinInitializationSettings();
    var initializationsSettings = new InitializationSettings(android: androidInitialize,
        iOS: iOSInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationsSettings );
  }

  static Future createScheduleNotification(ToDo todo) async {
    DateTime date = DateTime.parse("${todo.day} ${todo.time}").subtract(Duration(hours: 1));
    DateTime now = DateTime.now();

    Duration diff = Duration(seconds: 1);
    if(date.isAfter(now)){
      diff = date.difference(now);
    }

    AndroidNotificationDetails androidPlatformChannelSpecifics =
    new AndroidNotificationDetails(
      'you_can_name_it_whatever1',
      'channel_name',

      playSound: true,
      // sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max,
      priority: Priority.high,
    );

    var not= NotificationDetails(android: androidPlatformChannelSpecifics,
        iOS: DarwinNotificationDetails()
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(
        todo.id,
        todo.title,
        "Vào lúc ${todo.time}",
        tz.TZDateTime.now(tz.local).add(diff),
        not,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }
  static Future deleteScheduleNotification(ToDo todo) async {
    await flutterLocalNotificationsPlugin.cancel(todo.id);
  }
}