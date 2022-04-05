//
//  SettingsStore.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-12-06.
//

import Foundation
import struct SwiftUI.AppStorage

public protocol SettingsStore {

  /// A boolean value to determine whether the user has seen and completed
  /// with the onboarding experience (on first launch).
  var hasCompletedOnboarding: Bool { get set }

  /// A boolean value to determine whether the user has
  /// enabled APNs for `Noun O'Clock`.
  var isNewNounNotificationEnabled: Bool { get async }

  /// Changes the `OClock Notification` state persisted to the disk.
  func setNounOClockNotification(isEnabled: Bool) async
  
  /// A boolean value to determine whether the user has enabled APNs for `New Noun`.
  var isNounOClockNotificationEnabled: Bool { get async }
  
  /// Changes the `New Noun` notification state persisted to the disk.
  func setNewNounNotification(isEnabled: Bool) async
  
  /// Enables/disables the local persisted notification state for all notifications
  func setAllNotifications(isEnabled: Bool) async
  
  /// Sync locally stored notification states with the cloud to subscribe
  /// or unsubscribe from related topics.
  func syncMessagingTopicsSubscription()
}

/// A class to store, read, and update UserDefault values
public struct UserDefaultsSettingsStore: SettingsStore {
  
  /// Reference to the APNs service.
  private let messaging: Messaging
  
  public init(messaging: Messaging) {
    self.messaging = messaging
  }
  
  // MARK: - OnBoarding
  
  /// A persisted boolean indicates the onboarding completion state.
  @AppStorage("hasCompletedOnboarding") public var hasCompletedOnboarding = false
  
  // MARK: - Notification
  
  /// A persisted boolean indicates the noun OClock notification permission.
  @AppStorage("isNounOClockNotificationEnabled") private var _isNounOClockNotificationEnabled = true {
    didSet { syncMessagingTopicsSubscription() }
  }
  
  /// A boolean indicates whether the noun OClock notification is authorized. The state check
  /// validates whether the notification permission is allowed first for the app. Then check
  /// if persistent state `_isNewNounNotificationEnabled` is enabled.
  public var isNounOClockNotificationEnabled: Bool {
    get async {
      guard await isNotificationPermissionAuthorized else { return false }
      return _isNounOClockNotificationEnabled
    }
  }
  
  public func setNounOClockNotification(isEnabled: Bool) async {
    guard await isNotificationPermissionAuthorized else { return }
    
    _isNounOClockNotificationEnabled = isEnabled
  }
  
  /// A persisted boolean indicates a new noun noticiation permission.
  @AppStorage("isNewNounNotificationEnabled") private var _isNewNounNotificationEnabled = true {
    didSet { syncMessagingTopicsSubscription() }
  }
  
  /// A boolean indicates whether the new noun notification is authorized. The state check
  /// validates whether the notification permission is allowed first for the app. Then check
  /// if persistent state `_isNewNounNotificationEnabled` is enabled.
  public var isNewNounNotificationEnabled: Bool {
    get async {
      guard await isNotificationPermissionAuthorized else { return false }
      return _isNewNounNotificationEnabled
    }
  }
  
  public func setNewNounNotification(isEnabled: Bool) async {
    guard await isNotificationPermissionAuthorized else { return }
    
    _isNewNounNotificationEnabled = isEnabled
  }
  
  /// Lists the various available APNs topics.
  private enum MessagingTopic {
    static let auctionDidStart = "auction_did_start"
    static let auctionWillEnd = "auction_will_end"
  }
  
  public func syncMessagingTopicsSubscription() {
    Task {
      do {
        if await isNounOClockNotificationEnabled {
          try await messaging.subscribe(toTopic: MessagingTopic.auctionWillEnd)
        } else {
          try await messaging.unsubscribe(fromTopic: MessagingTopic.auctionWillEnd)
        }
        
        if await isNewNounNotificationEnabled {
          try await messaging.subscribe(toTopic: MessagingTopic.auctionDidStart)
        } else {
          try await messaging.unsubscribe(fromTopic: MessagingTopic.auctionDidStart)
        }
        
      } catch { }
    }
  }
  
  private var isNotificationPermissionAuthorized: Bool {
    get async {
      switch await messaging.authorizationStatus {
      case .authorized:
        return true
        
      default:
        return false
      }
    }
  }
  
  public func setAllNotifications(isEnabled: Bool) async {
    guard await isNotificationPermissionAuthorized else { return }
    
    _isNewNounNotificationEnabled = isEnabled
    _isNounOClockNotificationEnabled = isEnabled
  }
}
