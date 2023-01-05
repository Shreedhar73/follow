
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'id',
  'id',
  description: 'Used For Important Notifications',
  importance: Importance.high
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// final ReceivedNotification didReceiveLocalNotificationSubject;
// final String? selectNotificationSubject;
String? selectedNotificationPayload;

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}



 FirebaseMessaging messaging = FirebaseMessaging.instance;
 
  notificationInitialization() async {
   
    _requestPermissions();
    firebaseInitialize();
    String? fcm = await messaging.getToken();
    // box.write('fcm',fcm);
    debugPrint('FCM Token => $fcm');
  }

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
  }

  iosPermissionHandler() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    debugPrint('User granted permission: ${settings.authorizationStatus}');
  }

  firebaseInitialize() async {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
   
    const AndroidInitializationSettings initializationSettingsAndroid =AndroidInitializationSettings('@mipmap/ic_launcher');
   
    InitializationSettings initializationSettings = const InitializationSettings(
      android: initializationSettingsAndroid,
      
    );
    //Also If App is in Foreground
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: (NotificationResponse notificationResponse) {

    },
     
      
    );
    //If App is in Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              notification.hashCode.toString(),
              notification.title.toString(),
              channelDescription: notification.body,
              icon: '@mipmap/ic_launcher',
            ),
          ),
          payload: json.encode(message.data),
        );
      }
    });
    //If app is in Background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if(message.data.isNotEmpty){
        // notificClickNavigate(message);
      }else{
        // navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => const NotificationPage()));
      }
    });
    //If App is Closed/Killed
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message){
      if(message!=null){
        if(message.data.isNotEmpty){
          //::TODO
          // notificClickNavigateKilledState(message);
        }
      }
    });
  }
