import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'navigation/ai_recipe_navigation.dart';

// Local Notification plugin instance
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Background FCM handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('🔙 Background Message: ${message.messageId}');
}

// Request permission
Future<void> requestNotificationPermission() async {
  final status = await Permission.notification.request();
  if (status.isGranted) {
    print('Notification permission granted');
  } else if (status.isDenied || status.isPermanentlyDenied) {
    print(' Notification permission denied');
    await openAppSettings();
  }
}

// Initialize local notification settings
Future<void> initializeLocalNotifications() async {
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings settings =
      InitializationSettings(android: androidSettings);

  await flutterLocalNotificationsPlugin.initialize(settings);
}

// Show foreground notifications manually
Future<void> showNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'fcm_channel', // channel ID
    'FCM Notifications', // channel name
    channelDescription: 'This channel is used for FCM notifications',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    message.hashCode,
    message.notification?.title ?? 'Title',
    message.notification?.body ?? 'Body',
    notificationDetails,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
await FirebaseMessaging.instance.subscribeToTopic("minuteTopic");
  await requestNotificationPermission();
  await initializeLocalNotifications();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('📥 Foreground Message: ${message.messageId}');
    if (message.notification != null) {
      showNotification(message);
    }
  });

  String? token = await FirebaseMessaging.instance.getToken();
  print('📱 FCM Token: $token');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(300, 690),
      minTextAdapt: true,
      builder: (context, child) => MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
