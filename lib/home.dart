import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';

//importing notifications
import 'package:notifications_nav_app/services/notification_services.dart';

//importing all screens
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


// Create a global ValueNotifier for the switch state
final ValueNotifier<bool> _notificationEnabled = ValueNotifier<bool>(false);

// Create a global ValueNotifier for UI refresh
final ValueNotifier<int> uiRefreshNotifier = ValueNotifier<int>(0);

final NotificationService _notificationService = NotificationService();

class HomeScreen extends StatelessWidget {
  final VoidCallback toggleTheme;
  final ThemeMode themeMode;

  HomeScreen({
    super.key,
    required this.toggleTheme,
    required this.themeMode,
  }) : super();

  static final ValueNotifier<bool> allNotificationsDelivered = ValueNotifier<bool>(
    false,
  );

  //list of virtues
  static final List<String> virtues = [
    "test1",
    "test2",
    "test3",
    "test4",
    "test5",
    "test6",
    "test7",
    "test8",
    "test9",
    "test10",
    "test11",
    "test12",
    "test13",
    "test14",
  ];

  //list of virtue definitions
  static final List<String> definitions = [
    "This is Test1",
    "This is test2",
    "This is test3",
    "This is test4",
    "This is test5",
    "This is test6",
    "This is test7",
    "This is test8",
    "This is test9",
    "This is test10",
    "This is test11",
    "This is test12",
    "This is test13",
    "This is test14",
  ];

  //list of routes
  static final List<String> routes = [
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

  final String acronym = "\nDO MI NUSVO BRES\n";

  //oath
  final String oath =
      "\nDominus vobiscum et cum spiritu tuo. Kyrie eleison. Kyrie eleison. Christe eleison. Christe eleison. Kyrie eleison.\n";

  @override
  Widget build(BuildContext context) {
    // Load toggle state on first build
    _loadNotificationToggleStateOnce();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              'assets/images/tesla-truck.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ...virtues.asMap().entries.map((entry) {
                  final index = entry.key;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        foregroundColor: Theme.of(context).colorScheme.onSurface,
                        side: isDark ? const BorderSide(color: Colors.white, width: 1) : null,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => _getScreenForIndex(index),
                          ),
                        );
                      },
                      child: Text(
                        virtues[index],
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                }),
                ElevatedButton(
                  onPressed: () {
                    int randomInt = Random().nextInt(14);
                    NotificationService.showNotification(
                      id: 1,
                      title: virtues[randomInt],
                      body: definitions[randomInt],
                      payload: 'test_notification/' + virtues[randomInt],
                    );
                  },
                  child: Text("Send Notification"),
                ),
                const SizedBox(height: 16),
                
                Text(
                  acronym,
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                Text(
                  oath,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ValueListenableBuilder<int>(
                  valueListenable: uiRefreshNotifier,
                  builder: (context, refreshValue, child) {
                    return FutureBuilder<int?>(
                      future: _notificationService.getDaysRemaining(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text('Loading...');
                        } else if (snapshot.hasError) {
                          return Text('Error');
                        } else {
                          int daysRemaining = snapshot.data ?? 0;
                          debugPrint('UI: Days remaining loaded from SharedPreferences: ' + daysRemaining.toString());
                          return Text('Days remaining: $daysRemaining');
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                ValueListenableBuilder<bool>(
                  valueListenable: allNotificationsDelivered,
                  builder: (context, isCompleted, child) {
                    if (isCompleted) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        NotificationService.showNotification(
                          id: 999,
                          title: 'All Notifications Complete!',
                          body: 'Tap to open dialog to restart 14-day cycle',
                          payload: 'restart_dialog',
                        );
                        //Reset flag
                        allNotificationsDelivered.value = false;
                      });
                      
                    }
                    return Container();
                  },
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _notificationEnabled,
                  builder: (context, value, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Schedule Daily Notifications'),
                        const SizedBox(width: 8),
                        CupertinoSwitch(
                          value: value,
                          onChanged: (newValue) async {
                            _notificationEnabled.value = newValue;
                            // Persist the toggle state
                            await _notificationService.setNotificationToggleState(newValue);
                            if (newValue) {
                              // Show Cupertino date picker to select start date and time
                              final DateTime now = DateTime.now();
                              DateTime? selectedDateTime = await showCupertinoModalPopup<DateTime>(
                                context: context,
                                builder: (context) {
                                  DateTime tempDateTime = now;
                                  return Container(
                                    height: 320,
                                    color: CupertinoColors.systemBackground.resolveFrom(context),
                                    child: Column(
                                      children: [
                                        SafeArea(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(vertical: 8),
                                            color: CupertinoColors.systemGrey6.resolveFrom(context),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                CupertinoButton(
                                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                                  child: const Text('Cancel'),
                                                  onPressed: () => Navigator.of(context).pop(),
                                                ),
                                                CupertinoButton(
                                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                                  child: const Text('Done'),
                                                  onPressed: () => Navigator.of(context).pop(tempDateTime),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: CupertinoDatePicker(
                                            mode: CupertinoDatePickerMode.dateAndTime,
                                            initialDateTime: now,
                                            minimumDate: now,
                                            use24hFormat: false,
                                            maximumDate: now.add(const Duration(days: 365)),
                                            onDateTimeChanged: (DateTime newDateTime) {
                                              tempDateTime = newDateTime;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                              
                              if (selectedDateTime != null) {
                                // Always start at 14 when enabling notifications
                                await _notificationService.setDaysRemaining(14);
                                uiRefreshNotifier.value++;
                                // Schedule notifications from the selected date and time
                                await _notificationService.showDailyNotificationsFromDate(
                                  id: 0,
                                  titles: virtues,
                                  bodies: definitions,
                                  payloads: routes,
                                  startDate: selectedDateTime,
                                );
                                // Check if context is still mounted before using it
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Notifications scheduled starting ${selectedDateTime.toString().substring(0, 16)}'),
                                    ),
                                  );
                                }
                              } else {
                                // User cancelled, turn off the switch and reset days to 0
                                _notificationEnabled.value = false;
                                await _notificationService.setNotificationToggleState(false);
                                await _notificationService.setDaysRemaining(0);
                                uiRefreshNotifier.value++;
                              }
                            } else {
                              // Clear scheduled state when turning off
                              await _notificationService.setNotificationsScheduled(false);
                              await _notificationService.cancelAllNotifications();
                            }
                          },
                          activeTrackColor: Colors.green,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                // ElevatedButton(
                //   onPressed: () async {
                //     // Schedule for tomorrow at 9 AM
                //     final DateTime tomorrow = DateTime.now().add(const Duration(days: 1));
                //     final DateTime tomorrow9AM = DateTime(
                //       tomorrow.year,
                //       tomorrow.month,
                //       tomorrow.day,
                //       9, // 9 AM
                //       0, // 0 minutes
                //     );
                    
                //     await _notificationService.setDaysRemaining(14);
                //     uiRefreshNotifier.value++;
                    
                //     await _notificationService.showDailyNotificationsFromDate(
                //       id: 300,
                //       titles: virtues,
                //       bodies: definitions,
                //       payloads: routes,
                //       startDate: tomorrow9AM,
                //     );
                    
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       const SnackBar(
                //         content: Text('Notifications scheduled for tomorrow at 9:00 AM'),
                //       ),
                //     );
                //   },
                //   child: Text("Schedule for Tomorrow 9 AM"),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getScreenForIndex(int index) {
    switch (index) {
      case 0:
        return const Test1Screen();
      case 1:
        return const Test2Screen();
      case 2:
        return const Test3Screen();
      case 3:
        return const Test4Screen();
      case 4:
        return const Test5Screen();
      case 5:
        return const Test6Screen();
      case 6:
        return const Test7Screen();
      case 7:
        return const Test8Screen();
      case 8:
        return const Test9Screen();
      case 9:
        return const Test10Screen();
      case 10:
        return const Test11Screen();
      case 11:
        return const Test12Screen();
      case 12:
        return const Test13Screen();
      case 13:
        return const Test14Screen();
      default:
        return const Test1Screen();
    }
  }

  // Add this function to load the toggle state only once
  void _loadNotificationToggleStateOnce() {
    // Only load if the value is still the default (false) and not already loaded
    if (!_notificationEnabled.value) {
      NotificationService().getNotificationToggleState().then((savedValue) {
        _notificationEnabled.value = savedValue;
      });
    }
  }
}
