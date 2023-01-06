
// // import 'dart:convert';

// // import 'package:firebase_messaging/firebase_messaging.dart';
// // import 'package:flutter/foundation.dart';
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';


// // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// // final ReceivedNotification didReceiveLocalNotificationSubject;
// // final String? selectNotificationSubject;


 

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// late AndroidNotificationChannel channel;



// bool  isFlutterLocalNotificationsInitialized = false;

// String? selectedNotificationPayload;

// class ReceivedNotification {
//   ReceivedNotification({
//     required this.id,
//     required this.title,
//     required this.body,
//     required this.payload,
//   });

//   final int id;
//   final String? title;
//   final String? body;
//   final String? payload;
// }



//  FirebaseMessaging messaging = FirebaseMessaging.instance;
 
//   notificationInitialization() async {
   
//     _requestPermissions();
//     firebaseInitialize();
//     String? fcm = await messaging.getToken();
//     // box.write('fcm',fcm);
//     debugPrint('FCM Token => $fcm');
//   }

//   void _requestPermissions() {
//     flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
//       ?.requestPermissions(
//         alert: true,
//         badge: true,
//         sound: true,
//       );
//   }

//   iosPermissionHandler() async {
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//     debugPrint('User granted permission: ${settings.authorizationStatus}');
//   }

//   firebaseInitialize() async {
    
//     final NotificationAppLaunchDetails? notificationAppLaunchDetails =await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
   
//     const AndroidInitializationSettings initializationSettingsAndroid =AndroidInitializationSettings('@mipmap/ic_launcher');
   
//     InitializationSettings initializationSettings = const InitializationSettings(
//       android: initializationSettingsAndroid,
      
//     );
//     //Also If App is in Foreground
//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveBackgroundNotificationResponse: (NotificationResponse notificationResponse) {

//     },
     
      
//     );
//     //If App is in Foreground
    
//   }

//   listentoNotification(){
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       showNotification(message);
      
//     });
//     //If app is in Background
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       showNotification(message);
//     });
//     //If App is Closed/Killed
//     FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message){
//       showNotification(message!);
//     });
//   }
// Future<void> setupFlutterNotifications() async {
//   if (isFlutterLocalNotificationsInitialized) {
//     return;
//   }
//   channel = const AndroidNotificationChannel(
//     'high_importance_channel', // id
//     'High Importance Notifications', // title
//     description:
//         'This channel is used for important notifications.', // description
//     importance: Importance.high,
//   );

//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);

//   /// Update the iOS foreground notification presentation options to allow
//   /// heads up notifications.
//   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
//   isFlutterLocalNotificationsInitialized = true;
// }

// void showNotification(RemoteMessage message) {
//   RemoteNotification? notification = message.notification;
//   AndroidNotification? android = message.notification?.android;
//   if (notification != null && android != null && !kIsWeb) {
//     flutterLocalNotificationsPlugin.show(
//       notification.hashCode,
//       notification.title,
//       notification.body,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           channel.id,
//           channel.name,
//           channelDescription: channel.description,
//           // TODO add a proper drawable resource to android, for now using
//           //      one that already exists in example app.
//           icon: 'launch_background',
//         ),
//       ),
//     );
//   }
// }