import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'core/di/injection.dart';
import 'pages/home_page.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
// final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
//   BehaviorSubject<ReceivedNotification>();
//
// final BehaviorSubject<String?> selectNotificationSubject =
//   BehaviorSubject<String?>();
//
// const MethodChannel platform = MethodChannel('method_channel');
//
// class ReceivedNotification {
//   ReceivedNotification({
//     required this.id,
//     required this.title,
//     required this.body,
//     required this.payload,
//   });
//
//   final int id;
//   final String? title;
//   final String? body;
//   final String? payload;
// }
//
// String? selectedNotificationPayload;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureLocalTimeZone();
  initializeDi(GetIt.instance);

  // final NotificationAppLaunchDetails? notificationAppLaunchDetails =
  //   await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

//  String initialRoute = HomePage.routeName;

  // if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
  //   selectedNotificationPayload = notificationAppLaunchDetails!.payload;
  //   initialRoute = SecondPage.routeName;
  // }

//  await _notificationInit();

  // runApp(
  //   MaterialApp(
  //     initialRoute: initialRoute,
  //     routes: <String, WidgetBuilder>{
  //       HomePage.routeName: (_) => const MyHomePage(), //HomePage(notificationAppLaunchDetails),
  //       SecondPage.routeName: (_) => SecondPage(selectedNotificationPayload)
  //     },
  //   ),
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: const MyHomePage()
    );
  }
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
}

// Future<void> _notificationInit() async {
//   const AndroidInitializationSettings initializationSettingsAndroid =
//   AndroidInitializationSettings('app_icon');
//
//   final IOSInitializationSettings initializationSettingsIOS =
//   IOSInitializationSettings(
//       requestAlertPermission: false,
//       requestBadgePermission: false,
//       requestSoundPermission: false,
//       onDidReceiveLocalNotification: (
//           int id,
//           String? title,
//           String? body,
//           String? payload,
//           ) async {
//         didReceiveLocalNotificationSubject.add(
//           ReceivedNotification(
//             id: id,
//             title: title,
//             body: body,
//             payload: payload,
//           ),
//         );
//       });
//
//   final InitializationSettings initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//     iOS: initializationSettingsIOS,
//   );
//
//   await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//       onSelectNotification: (String? payload) async {
//         if (payload != null) {
//           debugPrint('notification payload: $payload');
//         }
//         selectedNotificationPayload = payload;
//         selectNotificationSubject.add(payload);
//       });
// }


// class PaddedElevatedButton extends StatelessWidget {
//   const PaddedElevatedButton({
//     required this.buttonText,
//     required this.onPressed,
//     Key? key,
//   }) : super(key: key);
//
//   final String buttonText;
//   final VoidCallback onPressed;
//
//   @override
//   Widget build(BuildContext context) => Padding(
//     padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
//     child: ElevatedButton(
//       onPressed: onPressed,
//       child: Text(buttonText),
//     ),
//   );
// }

// class HomePage extends StatefulWidget {
//   const HomePage(
//       this.notificationAppLaunchDetails, {
//         Key? key,
//       }) : super(key: key);
//
//   static const String routeName = '/';
//
//   final NotificationAppLaunchDetails? notificationAppLaunchDetails;
//
//   bool get didNotificationLaunchApp =>
//       notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;
//
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   @override
//   void initState() {
//     super.initState();
//     // _requestPermissions();
//     // _configureDidReceiveLocalNotificationSubject();
//     // _configureSelectNotificationSubject();
//   }
//
//   // void _requestPermissions() {
//   //   flutterLocalNotificationsPlugin
//   //       .resolvePlatformSpecificImplementation<
//   //       IOSFlutterLocalNotificationsPlugin>()
//   //       ?.requestPermissions(
//   //     alert: true,
//   //     badge: true,
//   //     sound: true,
//   //   );
//   // }
//   //
//   // void _configureDidReceiveLocalNotificationSubject() {
//   //   didReceiveLocalNotificationSubject.stream
//   //       .listen((ReceivedNotification receivedNotification) async {
//   //     await showDialog(
//   //       context: context,
//   //       builder: (BuildContext context) => CupertinoAlertDialog(
//   //         title: receivedNotification.title != null
//   //             ? Text(receivedNotification.title!)
//   //             : null,
//   //         content: receivedNotification.body != null
//   //             ? Text(receivedNotification.body!)
//   //             : null,
//   //         actions: <Widget>[
//   //           CupertinoDialogAction(
//   //             isDefaultAction: true,
//   //             onPressed: () async {
//   //               Navigator.of(context, rootNavigator: true).pop();
//   //               await Navigator.push(
//   //                 context,
//   //                 MaterialPageRoute<void>(
//   //                   builder: (BuildContext context) =>
//   //                       SecondPage(receivedNotification.payload),
//   //                 ),
//   //               );
//   //             },
//   //             child: const Text('Ok'),
//   //           )
//   //         ],
//   //       ),
//   //     );
//   //   });
//   // }
//   //
//   // void _configureSelectNotificationSubject() {
//   //   selectNotificationSubject.stream.listen((String? payload) async {
//   //     await Navigator.pushNamed(context, '/secondPage');
//   //   });
//   // }
//   //
//   // @override
//   // void dispose() {
//   //   didReceiveLocalNotificationSubject.close();
//   //   selectNotificationSubject.close();
//   //   super.dispose();
//   // }
//
//   @override
//   Widget build(BuildContext context) => MaterialApp(
//     home: Scaffold(
//       appBar: AppBar(
//         title: const Text('Notifications'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(8),
//           child: Center(
//             child: Column(
//               children: <Widget>[
//                 PaddedElevatedButton(
//                   buttonText: 'Show plain notification with payload',
//                   onPressed: () async {
// //                    await _showNotification();
//                   },
//                 ),
//                 PaddedElevatedButton(
//                   buttonText:
//                   'Schedule daily 10:00:00 am notification in your '
//                       'local time zone',
//                   onPressed: () async {
// //                    await _scheduleDailyTenAMNotification();
//                   },
//                 ),
//                 PaddedElevatedButton(
//                   buttonText:
//                   'Schedule weekly 10:00:00 am notification in your '
//                       'local time zone',
//                   onPressed: () async {
// //                    await _scheduleWeeklyTenAMNotification();
//                   },
//                 ),
//                 PaddedElevatedButton(
//                   buttonText:
//                   'Schedule weekly Monday 10:00:00 am notification '
//                       'in your local time zone',
//                   onPressed: () async {
// //                    await _scheduleWeeklyMondayTenAMNotification();
//                   },
//                 ),
//                 PaddedElevatedButton(
//                   buttonText:
//                   'Schedule monthly Monday 10:00:00 am notification in '
//                       'your local time zone',
//                   onPressed: () async {
//  //                   await _scheduleMonthlyMondayTenAMNotification();
//                   },
//                 ),
//                 const SizedBox(
//                   height: 50,
//                 ),
//                 PaddedElevatedButton(
//                   buttonText: 'Check pending notifications',
//                   onPressed: () async {
// //                    await _checkPendingNotificationRequests();
//                   },
//                 ),
//                 PaddedElevatedButton(
//                   buttonText: 'Cancel notification',
//                   onPressed: () async {
//  //                   await _cancelNotification();
//                   },
//                 ),
//                 PaddedElevatedButton(
//                   buttonText: 'Cancel all notifications',
//                   onPressed: () async {
// //                    await _cancelAllNotifications();
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     ),
//   );

  // Future<void> _showNotification() async {
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //   AndroidNotificationDetails('your channel id', 'your channel name',
  //       channelDescription: 'your channel description',
  //       importance: Importance.max,
  //       priority: Priority.high,
  //       ticker: 'ticker');
  //   const NotificationDetails platformChannelSpecifics =
  //     NotificationDetails(android: androidPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.show(
  //       0, 'plain title', 'plain body', platformChannelSpecifics,
  //       payload: 'item x');
  // }

  // Future<void> _cancelNotification() async {
  //   await flutterLocalNotificationsPlugin.cancel(0);
  // }

  // Future<void> _checkPendingNotificationRequests() async {
  //   final List<PendingNotificationRequest> pendingNotificationRequests =
  //   await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  //   return showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) => AlertDialog(
  //       content:
  //       Text('${pendingNotificationRequests.length} pending notification '
  //           'requests'),
  //       actions: <Widget>[
  //         TextButton(
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //           },
  //           child: const Text('OK'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Future<void> _cancelAllNotifications() async {
  //   await flutterLocalNotificationsPlugin.cancelAll();
  // }

  // Future<void> _scheduleDailyTenAMNotification() async {
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //       0,
  //       'daily scheduled notification title',
  //       'daily scheduled notification body',
  //       _nextInstanceOfTenAM(),
  //       const NotificationDetails(
  //         android: AndroidNotificationDetails('daily notification channel id',
  //             'daily notification channel name',
  //             channelDescription: 'daily notification description'),
  //       ),
  //       androidAllowWhileIdle: true,
  //       uiLocalNotificationDateInterpretation:
  //       UILocalNotificationDateInterpretation.absoluteTime,
  //       matchDateTimeComponents: DateTimeComponents.time);
  // }
  //
  // Future<void> _scheduleWeeklyTenAMNotification() async {
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //       0,
  //       'weekly scheduled notification title',
  //       'weekly scheduled notification body',
  //       _nextInstanceOfTenAM(),
  //       const NotificationDetails(
  //         android: AndroidNotificationDetails('weekly notification channel id',
  //             'weekly notification channel name',
  //             channelDescription: 'weekly notificationdescription'),
  //       ),
  //       androidAllowWhileIdle: true,
  //       uiLocalNotificationDateInterpretation:
  //       UILocalNotificationDateInterpretation.absoluteTime,
  //       matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  // }
  //
  // Future<void> _scheduleWeeklyMondayTenAMNotification() async {
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //       0,
  //       'weekly scheduled notification title',
  //       'weekly scheduled notification body',
  //       _nextInstanceOfMondayTenAM(),
  //       const NotificationDetails(
  //         android: AndroidNotificationDetails('weekly notification channel id',
  //             'weekly notification channel name',
  //             channelDescription: 'weekly notificationdescription'),
  //       ),
  //       androidAllowWhileIdle: true,
  //       uiLocalNotificationDateInterpretation:
  //       UILocalNotificationDateInterpretation.absoluteTime,
  //       matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  // }
  //
  // Future<void> _scheduleMonthlyMondayTenAMNotification() async {
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //       0,
  //       'monthly scheduled notification title',
  //       'monthly scheduled notification body',
  //       _nextInstanceOfMondayTenAM(),
  //       const NotificationDetails(
  //         android: AndroidNotificationDetails('monthly notification channel id',
  //             'monthly notification channel name',
  //             channelDescription: 'monthly notificationdescription'),
  //       ),
  //       androidAllowWhileIdle: true,
  //       uiLocalNotificationDateInterpretation:
  //         UILocalNotificationDateInterpretation.absoluteTime,
  //       matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime);
  // }
  //
  // tz.TZDateTime _nextInstanceOfTenAM() {
  //   final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  //   tz.TZDateTime scheduledDate =
  //   tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
  //   if (scheduledDate.isBefore(now)) {
  //     scheduledDate = scheduledDate.add(const Duration(days: 1));
  //   }
  //   return scheduledDate;
  // }
  //
  // tz.TZDateTime _nextInstanceOfMondayTenAM() {
  //   tz.TZDateTime scheduledDate = _nextInstanceOfTenAM();
  //   while (scheduledDate.weekday != DateTime.monday) {
  //     scheduledDate = scheduledDate.add(const Duration(days: 1));
  //   }
  //   return scheduledDate;
  // }

// }


// class SecondPage extends StatefulWidget {
//   const SecondPage(
//       this.payload, {
//         Key? key,
//       }) : super(key: key);
//
//   static const String routeName = '/secondPage';
//
//   final String? payload;
//
//   @override
//   State<StatefulWidget> createState() => SecondPageState();
// }

// class SecondPageState extends State<SecondPage> {
//   String? _payload;
//
//   @override
//   void initState() {
//     super.initState();
//     _payload = widget.payload;
//   }
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     appBar: AppBar(
//       title: Text('Second Screen with payload: ${_payload ?? ''}'),
//     ),
//     body: Center(
//       child: ElevatedButton(
//         onPressed: () {
//           Navigator.pop(context);
//         },
//         child: const Text('Go back!'),
//       ),
//     ),
//   );
// }

// class _InfoValueString extends StatelessWidget {
//   const _InfoValueString({
//     required this.title,
//     required this.value,
//     Key? key,
//   }) : super(key: key);
//
//   final String title;
//   final Object? value;
//
//   @override
//   Widget build(BuildContext context) => Padding(
//     padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
//     child: Text.rich(
//       TextSpan(
//         children: <InlineSpan>[
//           TextSpan(
//             text: '$title ',
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           TextSpan(
//             text: '$value',
//           )
//         ],
//       ),
//     ),
//   );
// }