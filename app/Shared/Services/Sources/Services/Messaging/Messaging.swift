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
  var notificationStateDidChange: AsyncStream<Void> { get }
  
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
  ///   - topic: The topic name to subscribe to, for example, @"sports".
  func unsubscribe(fromTopic topic: String) async throws
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
  }
  
}

extension FirebaseMessaging: Messaging {
  
  public var notificationStateDidChange: AsyncStream<Void> {
    AsyncStream { [weak self] continuation in
      
      let listener = FirebaseMessagingObservable()
      
      listener.didReceiveRegistrationToken = { fcmToken in
        self?.logger.debug("🏁 🆔 Firebase registration token: \(fcmToken ?? "⚠️ Unavailable")")
        
        continuation.yield()
      }
      
      continuation.onTermination = { @Sendable _ in
        listener.stop()
      }
    }
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
  
  @MainActor
  public func requestAuthorization(_ application: UIApplication, authorizationOptions: UNAuthorizationOptions) async throws -> Bool {
    let center = UNUserNotificationCenter.current()
    
    // Display notification (sent via APNS)
    center.delegate = self
    
    let authOptions: UNAuthorizationOptions = authorizationOptions
    async let requestAuthorization = center.requestAuthorization(options: authOptions)
    
    // Register for remote notification at all time in case
    // the user has authorized notification from the settings.
    application.registerForRemoteNotifications()
    
    return try await requestAuthorization
  }
  
  public func subscribe(toTopic topic: String) async throws {
    try await Firebase.Messaging.messaging().subscribe(toTopic: topic)
    logger.debug("🏁 Subscribed to topic: \(topic)")
  }
  
  public func unsubscribe(fromTopic topic: String) async throws {
    try await Firebase.Messaging.messaging().unsubscribe(fromTopic: topic)
    logger.debug("🏁 Unsubscribed to topic: \(topic)")
  }
}

extension FirebaseMessaging: UNUserNotificationCenterDelegate {
  
  // Receive displayed notifications for iOS 10 devices.
  public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    
    // Change this to your preferred presentation option
    completionHandler([[.banner, .list, .sound]])
  }
  
  public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    
    completionHandler()
  }
}

final class FirebaseMessagingObservable: NSObject, Firebase.MessagingDelegate {
  
  var didReceiveRegistrationToken: ((_ fcmToken: String?) -> Void)?
  
  override init() {
    super.init()
    // Use Firebase library to configure APIs
    Firebase.Messaging.messaging().delegate = self
  }
  
  func stop() {
    Firebase.Messaging.messaging().delegate = nil
  }
  
  // MARK: - Firebase.MessagingDelegate
  
  func messaging(_ messaging: Firebase.Messaging, didReceiveRegistrationToken fcmToken: String?) {
    didReceiveRegistrationToken?(fcmToken)
  }
}
