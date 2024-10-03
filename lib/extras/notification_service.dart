import 'package:coupon/extras/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:coupon/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PushNotifications {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future init() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
  }

  static Future getDeviceToken({int maxRetires = 3}) async {
    try {
      String? token;
      if (kIsWeb) {
        token = await _firebaseMessaging.getToken(
            vapidKey:
                "BIHUWiXNknQ3ccrJfkxvvVs9Fpu7EDS2Mo1lsPmYgPDBAdIYxXXV8G6ZtT-ACyR7AW6ahMC_pVIyVoytxGY_DYo");
        if (kDebugMode) {
          print("for web device token: $token");
        }
      } else {
        token = await _firebaseMessaging.getToken();
      }
      saveTokenToFirestore(token: token!);
      return token;
    } catch (e) {
      if (maxRetires > 0) {
        await Future.delayed(const Duration(seconds: 10));
        return getDeviceToken(maxRetires: maxRetires - 1);
      } else {
        return null;
      }
    }
  }

  static saveTokenToFirestore({required String token}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("userId")) {
      var url = Uri.http(ipAddress, "coupon/function/home.php");
      await http.post(url, body: {
        "method": "saveToken",
        "userId": prefs.getString("userId").toString(),
        "token": token,
      });
    }
    _firebaseMessaging.onTokenRefresh.listen((event) async {
      if (prefs.containsKey("userId")) {
        var url = Uri.http(ipAddress, "coupon/function/home.php");
        await http.post(url, body: {
          "method": "saveToken",
          "userId": prefs.getString("userId").toString(),
          "token": token,
        });
      }
    });
  }

  static Future localNotificationInit() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) {},
    );
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);

    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();

    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap);
  }

  static void onNotificationTap(NotificationResponse notificationResponse) {
    navigatorKey.currentState!
        .pushNamed("/message", arguments: notificationResponse);
  }

  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'in.rswm.coupon.notification', 'Coupon Notification',
            channelDescription: 'Notification from Coupon App',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);
  }
}
