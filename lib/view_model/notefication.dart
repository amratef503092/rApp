// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_native_timezone/flutter_native_timezone.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
//
// class NotificationApi {
//   static FlutterLocalNotificationsPlugin
//   flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//   static final onNotification = BehaviorSubject<String?>();
//
//   static Future init({bool initScdeuled = false}) async {
//     const android = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const settings = InitializationSettings(
//
//       android: android,
//     );
//
//     tz.initializeTimeZones();
//     final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
//     tz.setLocalLocation(tz.getLocation(timeZoneName));
//
//     final details =
//     await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
//     if (details != null && details.didNotificationLaunchApp) {
//       onNotification.add(details.notificationResponse?.payload);
//     }
//
//     await flutterLocalNotificationsPlugin.initialize(
//       settings,
//       onDidReceiveBackgroundNotificationResponse: (response)
//       {
//         onNotification.add(response.payload);
//       },
//
//       onDidReceiveNotificationResponse: (payload) {
//         onNotification.add(payload.payload);
//       },
//     );
//     if (initScdeuled) {
//       tz.initializeTimeZones();
//       final String timeZoneName =
//       await FlutterNativeTimezone.getLocalTimezone();
//       tz.setLocalLocation(tz.getLocation(timeZoneName));
//     }
//   }
//
//   void onClickedNotification(String? payload) {
//     print('onClickeNotification');
//     print(payload);
//   }
//
//   void cancelAll() async {
//     await flutterLocalNotificationsPlugin.cancelAll();
//   }
//
//   void cancel(int id) async {
//     await flutterLocalNotificationsPlugin.cancel(id);
//   }
//
//   static Future _notificationDetails() async {
//     return const NotificationDetails(
//       android: AndroidNotificationDetails(
//         'channel id',
//         'channel name',
//         importance: Importance.max,
//         priority: Priority.high,
//         playSound: true,
//         ticker: 'test ticker',
//       ),
//     );
//   }
//
//   static Future showNotification({
//     int id = 0,
//     String? title,
//     String? body,
//     String? payload,
//
//   }) async {
//     flutterLocalNotificationsPlugin
//         .show(id, title, body, await _notificationDetails(), payload: payload);
//   }
//
//   static Future ScheduleNotification
//       ({int id = 0,
//     String ? title,
//     String ? body,
//     String ? payload,
//     required DateTime dateTime}) async {
//     try {
//       return await flutterLocalNotificationsPlugin.
//       zonedSchedule(
//           id,
//           title,
//           body,
//           tz.TZDateTime.from(dateTime, tz.local),
//           await _notificationDetails(),
//           payload: payload,
//           androidAllowWhileIdle: true,
//           uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime);
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   static Future repetedNotification({int id = 0,
//     String? title,
//     String? body,
//     String? payload,
//     required DateTime dateTime}) async {
//     try {
//       return await flutterLocalNotificationsPlugin.
//       zonedSchedule(
//           id,
//           title,
//           body,
//           _scheduleDaily(const Time(10, 39, 2)),
//           await _notificationDetails(),
//           payload: payload,
//           androidAllowWhileIdle: true,
//           uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//           matchDateTimeComponents: DateTimeComponents.time);
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   static tz.TZDateTime _scheduleDaily(Time time) {
//     final now = tz.TZDateTime.now(tz.local);
//     tz.TZDateTime scheduledDate = tz.TZDateTime(
//         tz.local,
//         now.year,
//         now.month,
//         now.day,
//         time.hour,
//         time.minute,
//         time.second);
//     return scheduledDate.isBefore(now)
//         ? scheduledDate.add(const Duration(seconds: 2))
//         : scheduledDate;
//   }
//
//   static Future prodicNotification({
//     int id = 0,
//     String? title,
//     String? body,
//     String? payload,
//
//   }) async {
//     flutterLocalNotificationsPlugin
//         .periodicallyShow(id, title,
//         body,
//         RepeatInterval.everyMinute
//         , await _notificationDetails(), payload: payload);
//   }
//
//   static Future<void> _showNotificationWithActions() async {
//     const AndroidNotificationDetails androidNotificationDetails =
//     AndroidNotificationDetails(
//       'your channel id',
//       'your channel name',
//       channelDescription: 'your channel description',
//       importance: Importance.max,
//       priority: Priority.high,
//       ticker: 'ticker',
//       actions: <AndroidNotificationAction>[
//
//         AndroidNotificationAction(
//           '1',
//           'Action 3',
//           icon: DrawableResourceAndroidBitmap('secondary_icon'),
//           showsUserInterface: true,
//           // By default, Android plugin will dismiss the notification when the
//           // user tapped on a action (this mimics the behavior on iOS).
//           cancelNotification: false,
//         ),
//       ],
//     );
//   }
// }