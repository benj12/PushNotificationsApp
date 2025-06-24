import UIKit
import Flutter
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // Important line for iOS notifications:
    UNUserNotificationCenter.current().delegate = self

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // 🔔 Called when a notification is tapped (background/terminated)
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    let userInfo = response.notification.request.content.userInfo
    let payload = userInfo["payload"] as? String ?? ""
    
    print("iOS: Notification tapped with payload: \(payload)")
    
    // Let the Flutter plugin handle the response
    super.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
  }

  // 🔔 Handle notification received when app is in foreground
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    if #available(iOS 14.0, *) {
      completionHandler([.banner, .list, .sound])
    } else {
      completionHandler([.alert, .sound])
    }
  }
}


// import UIKit
// import Flutter
// import UserNotifications

// @main
// @objc class AppDelegate: FlutterAppDelegate {
  
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     GeneratedPluginRegistrant.register(with: self)

//     // Set notification delegate
//     UNUserNotificationCenter.current().delegate = self

//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }

//   // 🔔 Called when a notification is tapped (background/terminated)
//   override func userNotificationCenter(
//     _ center: UNUserNotificationCenter,
//     didReceive response: UNNotificationResponse,
//     withCompletionHandler completionHandler: @escaping () -> Void
//   ) {
//     let userInfo = response.notification.request.content.userInfo
//     let payload = userInfo["payload"] as? String ?? ""

//     if let controller = window?.rootViewController as? FlutterViewController {
//       let channel = FlutterMethodChannel(name: "notification_channel", binaryMessenger: controller.binaryMessenger)
//       channel.invokeMethod("notificationTapped", arguments: payload)
//     }

//     completionHandler()
//   }

//   // 🔔 Handle notification received when app is in foreground
//   override func userNotificationCenter(
//     _ center: UNUserNotificationCenter,
//     willPresent notification: UNNotification,
//     withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
//   ) {
//     if #available(iOS 14.0, *) {
//       completionHandler([.banner, .list, .sound])
//     } else {
//       completionHandler([.alert, .sound])
//     }
//   }
// }
