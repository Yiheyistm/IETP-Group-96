import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse response) async {});
    requestNotificationPermission();
  }

  Future<void> requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (!status.isGranted) {
      status = await Permission.notification.request();
      if (status.isGranted) {
        // Notification permission granted
      } else {
        // Handle the case where the user denied permission
      }
    }
  }

  notificationDetails() {
    return NotificationDetails(
        android: AndroidNotificationDetails("channelId", "channelName",
            importance: Importance.high, priority: Priority.high),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payload,
      String intesities = "Normal"}) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'threshold_channel', // Channel ID
      'Threshold Alerts', // Channel name
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title, // Notification title
      body, // Notification body
      notificationDetails,
    );
    if (await Vibration.hasVibrator() ?? false) {
      switch (intesities) {
        case "Normal":
          Vibration.vibrate(duration: 1000);
          break;
        case "Low":
          Vibration.vibrate(duration: 500, intensities: [128]);
          break;
        case "High":
          Vibration.vibrate(
              duration: 1000, intensities: [255, 300, 500, 800], repeat: 1);
          break;
        default:
          Vibration.vibrate(duration: 1000);
      }
    }
  }

  // Function to vibrate the phone
  void vibratePhone(
      {required int duration,
      required List<int> intesities,
      int repeat = -1}) async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(
          duration: duration,
          intensities: intesities,
          repeat: repeat); // Vibrate for 500ms
    }
  }
}