import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'my_channel', // id
  'My Channel', // title
  // 'Important notifications from my server.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class Notifications {
  static Future init() async {
    await Firebase.initializeApp();
    // var FirebaseMessaging;
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    firebaseMessaging.getToken();
    
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Notifications()._showNotification(message);
      // RemoteNotification notification = message.notification!;
      // AndroidNotification? android = message.notification?.android;
      // if (notification != null && android != null) {
      //   flutterLocalNotificationsPlugin.show(
      //       notification.hashCode,
      //       notification.title,
      //       notification.body,
      //       NotificationDetails(
      //         android: AndroidNotificationDetails(
      //           channel.id,
      //           channel.name,
      //           color: Colors.red,
      //           importance: Importance.max,
      //           priority: Priority.high,
       
      //           // channel.description,
      //           // icon: 'some_icon_in_drawable_folder',
      //         ),
      //       ));
      // }
    });

    //If app is in Background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      
      
    });
    //If App is Closed/Killed
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message){
      
      
    });
  }

  Future<void> _showNotification(message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: 'launch_background',
          ),
        ),
      );
    }
  }
}

