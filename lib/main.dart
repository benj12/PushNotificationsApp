import 'package:flutter/material.dart';

//importing all screens
import 'package:notifications_nav_app/home.dart';
import 'package:notifications_nav_app/screens/test1.dart';
import 'package:notifications_nav_app/screens/test2.dart';
import 'package:notifications_nav_app/screens/test3.dart';
import 'package:notifications_nav_app/screens/test4.dart';
import 'package:notifications_nav_app/screens/test5.dart';
import 'package:notifications_nav_app/screens/test6.dart';
import 'package:notifications_nav_app/screens/test7.dart';
import 'package:notifications_nav_app/screens/test8.dart';
import 'package:notifications_nav_app/screens/test9.dart';
import 'package:notifications_nav_app/screens/test10.dart';
import 'package:notifications_nav_app/screens/test11.dart';
import 'package:notifications_nav_app/screens/test12.dart';
import 'package:notifications_nav_app/screens/test13.dart';
import 'package:notifications_nav_app/screens/test14.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'services/notification_services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

NotificationService _notificationService = NotificationService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    debugPrint('Starting app initialization...');
    await NotificationService.init();
    debugPrint('Notification service initialized successfully');
  } catch (e) {
    debugPrint('Error initializing notification service: $e');
  }
  
  final NotificationAppLaunchDetails? notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  
  String initialRoute = '/';
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    String? selectedNotificationPayload = notificationAppLaunchDetails!.notificationResponse?.payload;
    debugPrint('App launched from notification with payload: $selectedNotificationPayload');

    if (selectedNotificationPayload != null && selectedNotificationPayload.isNotEmpty) {
      // Handle test notifications
      if (selectedNotificationPayload.startsWith('test_notification/')) {
        final parts = selectedNotificationPayload.split('/');
        if (parts.length == 2 && parts[1].isNotEmpty) {
          initialRoute = '/' + parts[1]; // e.g., /test1
          debugPrint('Setting initial route to: $initialRoute for test notification');
        } else {
          initialRoute = '/';
          debugPrint('Malformed test notification payload, defaulting to /');
        }
        // Do NOT decrement days for test notifications
      } else {
        initialRoute = selectedNotificationPayload;
        debugPrint('Setting initial route to: $initialRoute');
        // Handle notification tap when app is launched from notification
        if (selectedNotificationPayload != 'restart_dialog') {
          debugPrint('Processing regular notification payload: $selectedNotificationPayload');
          // Decrement days remaining
          int? storedDays = await _notificationService.getDaysRemaining();
          int currentDays = storedDays ?? 14;
          int newDays = currentDays - 1;

          if (newDays >= 0) {
            await _notificationService.setDaysRemaining(newDays);
            debugPrint('Days remaining updated to: $newDays');
          }
        } else {
          debugPrint('Processing restart dialog notification');
        }
      }
    } else {
      debugPrint('No valid notification payload found');
    }
  } else {
    debugPrint('App launched normally (not from notification)');
  }
  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatefulWidget {
  final String initialRoute;
  
  const MyApp({super.key, required this.initialRoute});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: NotificationService.navigatorKey,
      title: 'Notification Nav App',
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: _themeMode,
      initialRoute: widget.initialRoute,
      routes: {
        '/': (context) => HomeScreen(toggleTheme: toggleTheme, themeMode: _themeMode),
        '/test1': (context) => const Test1Screen(),
        '/test2': (context) => const Test2Screen(),
        '/test3': (context) => const Test3Screen(),
        '/test4': (context) => const Test4Screen(),
        '/test5': (context) => const Test5Screen(),
        '/test6': (context) => const Test6Screen(),
        '/test7': (context) => const Test7Screen(),
        '/test8': (context) => const Test8Screen(),
        '/test9': (context) => const Test9Screen(),
        '/test10': (context) => const Test10Screen(),
        '/test11': (context) => const Test11Screen(),
        '/test12': (context) => const Test12Screen(),
        '/test13': (context) => const Test13Screen(),
        '/test14': (context) => const Test14Screen(),
      },
    );
  }
}
