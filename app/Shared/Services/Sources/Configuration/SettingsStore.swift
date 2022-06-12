// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Mohammed Ibrahim
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
public class UserDefaultsSettingsStore: SettingsStore {
  
  private enum StoreKeys: String {
    case hasCompletedOnboarding
    case isNounOClockNotificationEnabled
    case isNewNounNotificationEnabled
  }
  
  /// Reference to the APNs service.
  private let messaging: Messaging
  
  /// Persistent storage for user preference.
  private let userDefaults: UserDefaults
  
  public convenience init(messaging: Messaging) {
    self.init(messaging: messaging, userDefaults: .standard)
  }
  
  init(messaging: Messaging, userDefaults: UserDefaults) {
    self.messaging = messaging
    self.userDefaults = userDefaults
  }
  
  // MARK: - OnBoarding
  
  /// A persisted boolean indicates the onboarding completion state.
  public var hasCompletedOnboarding: Bool {
    get { userDefaults.bool(forKey: StoreKeys.hasCompletedOnboarding.rawValue) }
    set { userDefaults.set(newValue, forKey: StoreKeys.hasCompletedOnboarding.rawValue) }
  }
  
  // MARK: - Notification
  
  /// A persisted boolean indicates the noun OClock notification permission.
  private var _isNounOClockNotificationEnabled: Bool {
    get { userDefaults.bool(forKey: StoreKeys.isNounOClockNotificationEnabled.rawValue) }
    set {
      userDefaults.set(newValue, forKey: StoreKeys.isNounOClockNotificationEnabled.rawValue)
      syncMessagingTopicsSubscription()
    }
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
  private var _isNewNounNotificationEnabled: Bool {
    get { userDefaults.bool(forKey: StoreKeys.isNewNounNotificationEnabled.rawValue) }
    set {
      userDefaults.set(newValue, forKey: StoreKeys.isNewNounNotificationEnabled.rawValue)
      syncMessagingTopicsSubscription()
    }
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
