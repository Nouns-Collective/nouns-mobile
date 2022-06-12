// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Ziad Tamim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import Foundation
import Firebase
import FirebaseMessaging
import UIKit.UIApplication
import os

public enum MessagingAuthorizationStatus {
  
  /// The user hasn't yet made a choice about whether the app is allowed to schedule notifications.
  case notDetermined

  /// The app isn't authorized to schedule or receive notifications.
  case denied
  
  /// The app is authorized to schedule or receive notifications.
  case authorized
  
  /// The application is provisionally authorized to post noninterruptive user notifications.
  case provisional
  
  /// The app is authorized to schedule or receive notifications for a limited amount of time.
  case ephemeral
}

public protocol Messaging: AnyObject {
  
  /// The app's ability to schedule and receive remote notifications.
  var authorizationStatus: MessagingAuthorizationStatus { get async }
  
  /// Asynchronously sets the event handler work item on received registration token.
  var notificationStateDidChange: NotificationCenter.Notifications { get }
  
  /// Requests authorization to interact with the user when local and remote
  /// notifications are delivered to the user’s device.
  ///
  /// - Parameters:
  ///  - application: The singleton app object.
  func requestAuthorization(_ application: UIApplication, authorizationOptions: UNAuthorizationOptions) async throws -> Bool
  
  /// Asynchronously subscribe to the provided topic, retrying on failure.
  ///
  /// - Parameters:
  ///   - topic: The topic name to subscribe to, for example, @"sports".
  func subscribe(toTopic topic: String) async throws
  
  /// Asynchronously unsubscribe from the provided topic, retrying on failure.
  ///
  /// - Parameters:
  ///   - topic: The topic name to unsubscribe from, for example, @"sports".
  func unsubscribe(fromTopic topic: String) async throws

  /// Notifies Analytics that a message was received
  func appDidReceiveNotification(_ payload: [AnyHashable: Any])
  
  func didRegisterForRemoteNotificationsWithDeviceToken(_ deviceToken: Data)
}

public class FirebaseMessaging: NSObject {
  
  private let logger = Logger(
    subsystem: "wtf.nouns.ios.services",
    category: "Messaging"
  )
  
  public override init() {
    super.init()
    
    if FirebaseApp.app() == nil {
      FirebaseApp.configure()
    }
    
    Firebase.Messaging.messaging().delegate = self

    // Receive APNs events via the Notification Center delegate
    UNUserNotificationCenter.current().delegate = self
  }
  
}

extension FirebaseMessaging: Messaging {
  
  public func update(token: Data) {
    Firebase.Messaging.messaging().apnsToken = token
  }
  
  public func didRegisterForRemoteNotificationsWithDeviceToken(_ deviceToken: Data) {
    Firebase.Messaging.messaging().apnsToken = deviceToken
  }
  
  public var notificationStateDidChange: NotificationCenter.Notifications {
    NotificationCenter.default.notifications(named: .MessagingRegistrationTokenRefreshed)
  }
  
  public var authorizationStatus: MessagingAuthorizationStatus {
    get async {
      await withCheckedContinuation { continuation in
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { [weak self] settings in
          
          switch settings.authorizationStatus {
          case .notDetermined:
            continuation.resume(returning: .notDetermined)
            
          case .denied:
            continuation.resume(returning: .denied)
            
          case .authorized:
            continuation.resume(returning: .authorized)
            
          case .provisional:
            continuation.resume(returning: .provisional)
            
          case .ephemeral:
            continuation.resume(returning: .ephemeral)
            
          @unknown default:
            self?.logger.error("💥 🔊 unknown authorization status for remote notifications.")
          }
        }
      }
    }
  }

  public func appDidReceiveNotification(_ payload: [AnyHashable: Any]) {
    Firebase.Messaging.messaging().appDidReceiveMessage(payload)
  }
  
  @MainActor
  public func requestAuthorization(_ application: UIApplication, authorizationOptions: UNAuthorizationOptions) async throws -> Bool {

    let center = UNUserNotificationCenter.current()

    let authOptions: UNAuthorizationOptions = authorizationOptions
    async let requestAuthorization = center.requestAuthorization(options: authOptions)

    return try await requestAuthorization
  }
  
  public func subscribe(toTopic topic: String) async throws {
    try await Firebase.Messaging.messaging().subscribe(toTopic: topic)
    logger.debug("🏁 Subscribed to topic: \(topic)")
  }
  
  public func unsubscribe(fromTopic topic: String) async throws {
    try await Firebase.Messaging.messaging().unsubscribe(fromTopic: topic)
    logger.debug("🏁 Unsubscribed from topic: \(topic)")
  }
}

extension FirebaseMessaging: UNUserNotificationCenterDelegate {
  
  // Receive displayed notifications for iOS 10 devices.
  public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

    appDidReceiveNotification(notification.request.content.userInfo)

    // Change this to your preferred presentation option
    completionHandler([[.banner, .list, .sound]])
  }
  
  public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    
    completionHandler()
  }
}

extension FirebaseMessaging: Firebase.MessagingDelegate {
  
  public func messaging(_ messaging: Firebase.Messaging, didReceiveRegistrationToken fcmToken: String?) {
    logger.debug("🏁 🆔 Firebase registration token: \(fcmToken ?? "⚠️ Unavailable")")
  }
}
