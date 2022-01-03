//
//  NounsApp.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-09-28.
//

import SwiftUI
import UIComponents
import Services

struct NounComposerKey: EnvironmentKey {
  static var defaultValue: NounComposer = AppCore.shared.nounComposer
}

extension EnvironmentValues {
    
    var nounComposer: NounComposer {
        get { self[NounComposerKey.self] }
        set { self[NounComposerKey.self] = newValue }
    }
}

@main
struct NounsApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  private var nounComposer = AppCore.shared.nounComposer
  
  init() {
    UIComponents.configure()
  }
  
  var body: some Scene {
    WindowGroup {
      RouterView()
        .environment(\.nounComposer, nounComposer)
        .preferredColorScheme(.light)
    }
  }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
//    FirebaseApp.configure()
//    
//    Messaging.messaging().delegate = self
//    
//    // For iOS 10 display notification (sent via APNS)
//    UNUserNotificationCenter.current().delegate = self
//
//    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//    UNUserNotificationCenter.current().requestAuthorization(
//      options: authOptions,
//      completionHandler: { _, _ in }
//    )
//
//    application.registerForRemoteNotifications()

    return true
  }
  
//  func application(
//    _ application: UIApplication,
//    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
//  ) {
//    Messaging.messaging().apnsToken = deviceToken
//  }
//
//  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//
//  }
}

///// Cloud Messaging
//extension AppDelegate: MessagingDelegate {
//
//  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//    print("Firebase registration token: \(String(describing: fcmToken))")
//
//    let dataDict: [String: String] = ["token": fcmToken ?? ""]
//    NotificationCenter.default.post(
//      name: Notification.Name("FCMToken"),
//      object: nil,
//      userInfo: dataDict
//    )
//  }
//}
//
///// User Notifications
//extension AppDelegate: UNUserNotificationCenterDelegate {
//
//  func userNotificationCenter(
//    _ center: UNUserNotificationCenter,
//    willPresent notification: UNNotification,
//    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
//  ) {
//    let userInfo = notification.request.content.userInfo
//
//    Messaging.messaging().appDidReceiveMessage(userInfo)
//
//    // Change this to your preferred presentation option
//    completionHandler([[.banner, .sound]])
//  }
//
//  func userNotificationCenter(
//    _ center: UNUserNotificationCenter,
//    didReceive response: UNNotificationResponse,
//    withCompletionHandler completionHandler: @escaping () -> Void
//  ) {
//    let userInfo = response.notification.request.content.userInfo
//
//    Messaging.messaging().appDidReceiveMessage(userInfo)
//
//    completionHandler()
//  }
//
//  func application(
//    _ application: UIApplication,
//    didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
//  ) {
//    Messaging.messaging().appDidReceiveMessage(userInfo)
//    completionHandler(.noData)
//  }
//}
