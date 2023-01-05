
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:follow/features/authentication/blocs/login_bloc.dart';
import 'package:follow/features/authentication/login_page.dart';
import 'package:follow/firebase_options.dart';

import 'features/firebase_notifications/fcm_config.dart';
import 'injection_container/injection.dart' as ic;
Future<void> myBackgroundMessageHandler(message) async {
  await Firebase.initializeApp();
  try {
    var notification = ReceivedNotification(
      id: message.data['id'],
      title: message.data['title'] ?? "",
      body: message.data['body'] ?? "",
      payload: message.data['payload']
    );
   

   
    
  } catch (e) {
    print("background error $e");
  }
  return Future<void>.value();
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await ic.init();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    firebaseInitialize();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginBloc()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
         
          primarySwatch: Colors.blue,
        ),
        home: const AuthGate(),
      ),
    );
  }
}
