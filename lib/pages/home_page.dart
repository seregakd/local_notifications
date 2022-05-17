import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:local_notifications/utils/notification_service.dart';
import '../data/storage/notifications_storage.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final NotificationsStorage _notificationsStorage = GetIt.instance<NotificationsStorage>();
  final NotificationService _notificationService = GetIt.instance<NotificationService>();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _dateTimeNotification = '';
  bool _onNotification = false;

  @override
  void initState() {
    _getNotificationInfo();
    _notificationInit();
    _requestPermissions();
    /// Payload
    // _configureDidReceiveLocalNotificationSubject();
    // _configureSelectNotificationSubject();
    super.initState();
  }

  @override
  void dispose() {
    /// Payload
    // didReceiveLocalNotificationSubject.close();
    // selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20.0,),
            Text(_dateTimeNotification),
            const SizedBox(height: 50.0,),
            Text("${_selectedDate.toLocal()}".split(' ')[0]),
            RaisedButton(
              onPressed: () => _selectDate(context),
              child: const Text('Select date'),
            ),
            const SizedBox(height: 20.0,),
            Text('${_selectedTime.hour}:${_selectedTime.minute}'),
            RaisedButton(
              onPressed: () => _selectTime(context),
              child: const Text('Select time'),
            ),
            const SizedBox(height: 20.0,),
            const Text('Set notification'),
            CupertinoSwitch(
              value: _onNotification,
              onChanged: (_) {
                _switchChanged();
              },
              activeColor: Colors.greenAccent,
            ),
            const SizedBox(height: 20.0,),
            RaisedButton(
              onPressed: () => _showNotification(
                context: context,
                title: 'title',
                body: 'body',
              ),
              child: const Text('show notification'),
            ),
            const SizedBox(height: 20.0,),
            RaisedButton(
              onPressed: () {
                _checkPendingNotificationRequests();
              },
              child: const Text('check Pending Notification Requests'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2030));
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,

    );
    if (timeOfDay != null && timeOfDay != _selectedTime) {
      setState(() {
        _selectedTime = timeOfDay;
      });
    }
  }

  void _setNotification({
    required BuildContext context,
    required String title,
    required String body,
    required DateTime dateTime,
  }) async{
    await _notificationService.scheduleNotification(
      title: title,
      body: body,
      dateTime: dateTime,
    );

    String date = DateFormat('yyyy-MM-dd').format(_selectedDate);
    String time = '${_selectedTime.hour}:${_selectedTime.minute}'; //_selectedTime.format(context);
    await _notificationsStorage.saveDate(date);
    await _notificationsStorage.saveTime(time);
    setState(() {
      _dateTimeNotification = '$date $time';
    });
  }

  void _showNotification({
    required BuildContext context,
    required String title,
    required String body,
  }) async{
    await _notificationService.showNotification(title: title, body: body);
  }

  Future<void> _cancelNotification() async {
    await _notificationService.cancelNotification();
    await _notificationsStorage.clearNotification();
    setState(() {
      _dateTimeNotification = '';
    });
  }

  Future<void> _checkPendingNotificationRequests() async {
    await _notificationService.checkPendingNotificationRequests(context);
  }

  void _getNotificationInfo() async{
    String date = await _notificationsStorage.getDate();
    if (date.isNotEmpty) {
      String time = await _notificationsStorage.getTime();
      if (time.isNotEmpty) {
        setState(() {
          _dateTimeNotification = '$date $time';
          _onNotification = true;
        });
      }
    }
  }

  void _notificationInit() async{
    await _notificationService.notificationInit();
  }

  void _requestPermissions() {
    _notificationService.flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _switchChanged() {
    DateTime scheduledDate = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    int difference = scheduledDate.difference(DateTime.now()).inSeconds;

    if (!_onNotification) {
      if (difference > 10) {
        _setNotification(
          context: context,
          title: 'title',
          body: 'body',
          dateTime: scheduledDate,
        );
        setState(() {
          _onNotification = !_onNotification;
        });
      } else {
        const snackBar = SnackBar(
          content: Text('Date must be in the future!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      _cancelNotification();
      setState(() {
        _onNotification = !_onNotification;
      });
    }


  }

/// Payload
  // void _configureDidReceiveLocalNotificationSubject() {
  //   didReceiveLocalNotificationSubject.stream
  //       .listen((ReceivedNotification receivedNotification) async {
  //     await showDialog(
  //       context: context,
  //       builder: (BuildContext context) => CupertinoAlertDialog(
  //         title: receivedNotification.title != null
  //             ? Text(receivedNotification.title!)
  //             : null,
  //         content: receivedNotification.body != null
  //             ? Text(receivedNotification.body!)
  //             : null,
  //         actions: <Widget>[
  //           CupertinoDialogAction(
  //             isDefaultAction: true,
  //             onPressed: () async {
  //               Navigator.of(context, rootNavigator: true).pop();
  //               await Navigator.push(
  //                 context,
  //                 MaterialPageRoute<void>(
  //                   builder: (BuildContext context) =>
  //                       SecondPage(receivedNotification.payload),
  //                 ),
  //               );
  //             },
  //             child: const Text('Ok'),
  //           )
  //         ],
  //       ),
  //     );
  //   });
  // }
  //
  // void _configureSelectNotificationSubject() {
  //   selectNotificationSubject.stream.listen((String? payload) async {
  //     await Navigator.pushNamed(context, '/secondPage');
  //   });
  // }

}
