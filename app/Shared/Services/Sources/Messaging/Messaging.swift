//
//  Messaging.swift
//  
//
//  Created by Ziad Tamim on 03.01.22.
//

import Foundation
import Firebase
import FirebaseMessaging
import UIKit.UIApplication
import os.log

public protocol Messaging: AnyObject {
  
  /// Requests authorization to interact with the user when local and remote
  /// notifications are delivered to the user’s device.
  ///
  /// - Parameters:
  ///  - application: The singleton app object.
  func requestAutorization(for application: UIApplication, completionHandler: @escaping (Bool, Error?) -> Void)
  
  func subscribe(toTopic topic: String) async throws
}

public class FirebaseMessagingProvider: NSObject, Messaging {
  
  public override init() {
    super.init()
    
    if FirebaseApp.app() == nil {
      FirebaseApp.configure()
    }
  }
  
  public func requestAutorization(for application: UIApplication, completionHandler: @escaping (Bool, Error?) -> Void) {
    // Use Firebase library to configure APIs
    FirebaseMessaging.Messaging.messaging().delegate = self
    
    // For iOS 10 display notification (sent via APNS)
    UNUserNotificationCenter.current().delegate = self
    
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(
      options: authOptions,
      completionHandler: completionHandler
    )
    
    application.registerForRemoteNotifications()
  }
  
  public func subscribe(toTopic topic: String) async throws {
    try await FirebaseMessaging.Messaging.messaging().subscribe(toTopic: topic)
  }
}

// MARK: - UIApplicationDelegate

extension FirebaseMessagingProvider {
  
  func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable : Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      
    }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    FirebaseMessaging.Messaging.messaging().apnsToken = deviceToken
  }
  
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    
  }
}

extension FirebaseMessagingProvider: UNUserNotificationCenterDelegate {
  
  // Receive displayed notifications for iOS 10 devices.
  public func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      let userInfo = notification.request.content.userInfo
      
      FirebaseMessaging.Messaging.messaging().appDidReceiveMessage(userInfo)
      
      // Change this to your preferred presentation option
      completionHandler([[.banner, .list, .sound]])
    }
  
  public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    
    FirebaseMessaging.Messaging.messaging().appDidReceiveMessage(userInfo)
    
    completionHandler()
  }
}

extension FirebaseMessagingProvider: FirebaseMessaging.MessagingDelegate {
  
  private func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    os_log("Firebase registration token: ", type: .info, String(describing: fcmToken))
  }
}
