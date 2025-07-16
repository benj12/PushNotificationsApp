import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:notifications_nav_app/home.dart';
// import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Simple ValueNotifier to trigger UI rebuilds
final ValueNotifier<int> uiRefreshNotifier = ValueNotifier<int>(0);

final NotificationService _notificationService = NotificationService();
class NotificationService {




  static const List<String> routes = [
    '/test1',
    '/test2',
    '/test3',
    '/test4',
    '/test5',
    '/test6',
    '/test7',
    '/test8',
    '/test9',
    '/test10',
    '/test11',
    '/test12',
    '/test13',
    '/test14',
  ];
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  
  var prefs;
  int dailyNotifyCounter = 0;
  String counterKey = 'dailyNotifyCounter';
  
  static Future<void> init() async {
    try {
      debugPrint('Initializing notification service...');
      tz.initializeTimeZones();
    
    // Use device's local timezone
    try {
      // Get the current timezone offset and try to match it to a known timezone
      final DateTime now = DateTime.now();
      final Duration offset = now.timeZoneOffset;
      
      // Common timezone mappings based on offset
      String timezoneName = 'UTC';
      if (offset.inHours == -5) {
        timezoneName = 'America/New_York';
      } else if (offset.inHours == -6) {
        timezoneName = 'America/Chicago';
      } else if (offset.inHours == -7) {
        timezoneName = 'America/Denver';
      } else if (offset.inHours == -8) {
        timezoneName = 'America/Los_Angeles';
      } else if (offset.inHours == 0) {
        timezoneName = 'Europe/London';
      } else if (offset.inHours == 1) {
        timezoneName = 'Europe/Paris';
      } else if (offset.inHours == 2) {
        timezoneName = 'Europe/Helsinki';
      } else if (offset.inHours == 5) {
        timezoneName = 'Asia/Kolkata';
      } else if (offset.inHours == 8) {
        timezoneName = 'Asia/Shanghai';
      } else if (offset.inHours == 9) {
        timezoneName = 'Asia/Tokyo';
      } else if (offset.inHours == 10) {
        timezoneName = 'Australia/Sydney';
      }
      
      tz.setLocalLocation(tz.getLocation(timezoneName));
    } catch (e) {
      // Fallback to system local timezone
      tz.setLocalLocation(tz.local);
    }
    
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        final payload = response.payload;
        debugPrint('Notification tapped with payload: $payload');

        // Handle test notifications: navigate, but do not decrement days
        if (payload != null && payload.startsWith('test_notification/')) {
          final parts = payload.split('/');
          if (parts.length == 2 && parts[1].isNotEmpty) {
            final route = '/' + parts[1]; // e.g., test1 -> /test1
            try {
              if (navigatorKey.currentState != null) {
                navigatorKey.currentState!.pushNamed(route);
                debugPrint('Navigated to $route for test notification');
              } else {
                debugPrint('Navigator state is null, cannot navigate for test notification');
              }
            } catch (e) {
              debugPrint('Navigation error for test notification: $e');
            }
          } else {
            debugPrint('Malformed test notification payload: $payload');
          }
          debugPrint('RETURNING after handling test notification, will NOT decrement days remaining');
          return; // Make sure to return so decrement logic is NOT executed
        }

        if (payload != null && payload.isNotEmpty) {
          // Handle restart dialog notification first
          if (payload == 'restart_dialog') {
            debugPrint('Routing to restart dialog');
            if (navigatorKey.currentContext != null) {
              _notificationService.showRestartDailyNotificationDialog(
                navigatorKey.currentContext!,
              );
            }
            return; // Exit early to avoid regular navigation logic
          }
          
          // Handle regular notification navigation
          debugPrint('Routing to page: $payload');
          try {
            if (navigatorKey.currentState != null) {
              navigatorKey.currentState!.pushNamed(payload);
              debugPrint('Successfully navigated to: $payload');
            } else {
              debugPrint('Navigator state is null, cannot navigate');
            }
          } catch (e) {
            debugPrint('Error navigating to $payload: $e');
          }
          
          // Decrement days remaining
          int? storedDays = await _notificationService.getDaysRemaining();
          int currentDays = storedDays ?? 14;
          int newDays = currentDays - 1;
          
          if (newDays >= 0) {
            await _notificationService.setDaysRemaining(newDays);
            debugPrint('Days remaining updated to: $newDays');
            // Trigger UI refresh
            uiRefreshNotifier.value++;
          }

          // Check if this was the last notification (/test14)
          if (payload == '/test14') {
            debugPrint('Last notification reached, setting completion flag');
            HomeScreen.allNotificationsDelivered.value = true;
          }
        } else {
          debugPrint('Notification payload is null or empty');
        }
      },
    );
    } catch (e) {
      debugPrint('Error initializing notification service: $e');
    }
  }



  Future<int> getDaysRemaining() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getInt(counterKey) ?? 0;
  }
  Future<void> setDaysRemaining(int count) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setInt(counterKey, count);
  }
  Future<void> clearDaysRemaining() async {
    prefs = await SharedPreferences.getInstance();
    await prefs.remove(counterKey);
  }
  Future<List<String>> getClickedNotifications() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('clickedNotifications') ?? [];
  }
  Future<void> setClickedNotifications(List<String> notifications) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('clickedNotifications', notifications);
  }
  Future<bool> areNotificationsScheduled() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getBool('notificationsScheduled') ?? false;
  }
  Future<void> setNotificationsScheduled(bool scheduled) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsScheduled', scheduled);
  }

  // Persist notification toggle state
  static const String notificationToggleKey = 'notification_toggle_enabled';

  Future<bool> getNotificationToggleState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(notificationToggleKey) ?? false;
  }

  Future<void> setNotificationToggleState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(notificationToggleKey, value);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    await setDaysRemaining(0);
    debugPrint('cancelAllNotifications: days remaining set to 0');
    uiRefreshNotifier.value++;
  }

  // Get current timezone information
  String getCurrentTimezone() {
    try {
      final DateTime now = DateTime.now();
      final Duration offset = now.timeZoneOffset;
      final String offsetString = offset.isNegative 
          ? '-${offset.inHours.abs()}:${(offset.inMinutes.abs() % 60).toString().padLeft(2, '0')}'
          : '+${offset.inHours}:${(offset.inMinutes % 60).toString().padLeft(2, '0')}';
      
      return 'Local Timezone (UTC$offsetString)';
    } catch (e) {
      return 'Local Timezone (Unknown)';
    }
  }

  // Set a specific timezone manually
  static Future<void> setSpecificTimezone(String timezoneName) async {
    try {
      tz.setLocalLocation(tz.getLocation(timezoneName));
    } catch (e) {
      debugPrint('Invalid timezone: $timezoneName');
      // Fallback to local timezone
      tz.setLocalLocation(tz.local);
    }
  }

  // Test method to manually decrement counter
  Future<void> testDecrement() async {
    int? storedDays = await getDaysRemaining();
    int currentDays = storedDays ?? 14;
    int newDays = currentDays - 1;
    await setDaysRemaining(newDays);
    uiRefreshNotifier.value++;
  }

  @pragma('vm:entry-point')
  void notificationTapBackground(NotificationResponse response) async {
    debugPrint('Background notification tapped with payload: ${response.payload}');
    
    try {
      // Handle notification tap when app is closed
      final payload = response.payload;
      if (payload != null && payload.isNotEmpty && payload != 'restart_dialog') {
        debugPrint('Processing background notification: $payload');
        // Decrement days remaining
        int? storedDays = await getDaysRemaining();
        int currentDays = storedDays ?? 14;
        int newDays = currentDays - 1;
        
        if (newDays >= 0) {
          await setDaysRemaining(newDays);
          debugPrint('Background: Days remaining updated to: $newDays');
        }
      } else {
        debugPrint('Background: Invalid or restart dialog payload: $payload');
      }
    } catch (e) {
      debugPrint('Error handling background notification: $e');
    }
  }
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    try {
      debugPrint('Showing notification: $title with payload: $payload');
      
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'main_channel',
        'Main Channel',
        importance: Importance.max,
        priority: Priority.high,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        notificationDetails,
        payload: payload,
      );
      
      debugPrint('Notification shown successfully');
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }

  Future<void> showDailyNotifications({
    required int id,
    required List<String> titles,
    required List<String> bodies,
    required List<String> payloads,
    required DateTime time,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'main_channel',
      'Main Channel',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    for (int i = 0; i < titles.length; i++) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id + i,
        titles[i],
        bodies[i],
        tz.TZDateTime.from(time.add(Duration(days: i)), tz.local),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payloads[i],
      );
    }
  }

  // Schedule notifications for a specific time each day
  Future<void> showDailyNotificationsAtTime({
    required int id,
    required List<String> titles,
    required List<String> bodies,
    required List<String> payloads,
    required int hour,
    required int minute,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'main_channel',
      'Main Channel',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Get current date
    final DateTime now = DateTime.now();
    
    for (int i = 0; i < titles.length; i++) {
      // Calculate the target date for this notification
      DateTime targetDate = DateTime(now.year, now.month, now.day + i, hour, minute);
      
      // If the target time has already passed today, schedule for tomorrow
      if (targetDate.isBefore(now)) {
        targetDate = targetDate.add(const Duration(days: 1));
      }
      
      // Convert to timezone-aware datetime
      final tz.TZDateTime scheduledDate = tz.TZDateTime.from(targetDate, tz.local);
      
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id + i,
        titles[i],
        bodies[i],
        scheduledDate,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payloads[i],
      );
    }
  }

  // Schedule notifications starting from a specific date and time
  Future<void> showDailyNotificationsFromDate({
    required int id,
    required List<String> titles,
    required List<String> bodies,
    required List<String> payloads,
    required DateTime startDate,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'main_channel',
      'Main Channel',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    for (int i = 0; i < titles.length; i++) {
      // Calculate the target date for this notification
      DateTime targetDate = startDate.add(Duration(days: i));
      
      // Convert to timezone-aware datetime
      final tz.TZDateTime scheduledDate = tz.TZDateTime.from(targetDate, tz.local);
      
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id + i,
        titles[i],
        bodies[i],
        scheduledDate,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payloads[i],
      );
    }
  }

  //restart daily notifications
  Future<bool?> showRestartDailyNotificationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Restart Notifications'),
          content: Text('Do you want to restart the 14-day daily notifications?'),
          actions: [
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
                flutterLocalNotificationsPlugin.cancelAll();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                Navigator.of(context).pop(true);
                await flutterLocalNotificationsPlugin.cancelAll();
                
                // Reset to 14 and clear clicked notifications
                await _notificationService.setClickedNotifications([]);
                await _notificationService.setDaysRemaining(14);
                HomeScreen.allNotificationsDelivered.value = false;
                
                // Show time picker for restart
                final TimeOfDay? selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                
                if (selectedTime != null) {
                  await _notificationService.showDailyNotificationsAtTime(
                    id: 0,
                    titles: HomeScreen.virtues,
                    bodies: HomeScreen.definitions,
                    payloads: HomeScreen.routes,
                    hour: selectedTime.hour,
                    minute: selectedTime.minute,
                  );
                }
              }
            )
          ]
        );
      }
    );
  }

  
}
