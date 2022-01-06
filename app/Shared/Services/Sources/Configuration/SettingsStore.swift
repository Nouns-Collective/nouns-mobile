//
//  SettingsStore.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-12-06.
//

import Foundation
import SwiftUI

public protocol SettingsStore {

  /// A boolean value to determine whether the user has seen and completed
  /// with the onboarding experience (on first launch).
  var hasCompletedOnboarding: Bool { get set }

  /// A boolean value to determine whether the user has
  /// enabled APNs for `Noun O'Clock`.
  var isNewNounNotificationEnabled: Bool { get set }

  /// A boolean value to determine whether the user has enabled APNs for `New Noun`.
  var isNounOClockNotificationEnabled: Bool { get set }
  
  /// Sync locally stored notification states with the cloud to subscribe
  /// or unsubscribe from related topics.
  func syncMessagingTopicsSubscription()
}

/// A class to store, read, and update UserDefault values
public struct UserDefaultsSettingsStore: SettingsStore {
  
  /// Lists the various available APNs topics.
  private enum MessagingTopic {
    static let auctionDidStart = "auction_did_start"
    static let auctionWillEnd = "auction_will_end"
  }
  
  @AppStorage("hasCompletedOnboarding") public var hasCompletedOnboarding = false
  
  @AppStorage("isNounOClockNotificationEnabled") public var isNounOClockNotificationEnabled = true {
    didSet { syncMessagingTopicsSubscription() }
  }
  
  @AppStorage("isNewNounNotificationEnabled") public var isNewNounNotificationEnabled = true {
    didSet { syncMessagingTopicsSubscription() }
  }
  
  /// Reference to the APNs service.
  private let messaging: Messaging
  
  public init(messaging: Messaging) {
    self.messaging = messaging
  }
  
  public func syncMessagingTopicsSubscription() {
    Task {
      do {
        if isNounOClockNotificationEnabled {
          try await messaging.subscribe(toTopic: MessagingTopic.auctionWillEnd)
        } else {
          try await messaging.unsubscribe(fromTopic: MessagingTopic.auctionWillEnd)
        }
        
        if isNewNounNotificationEnabled {
          try await messaging.subscribe(toTopic: MessagingTopic.auctionDidStart)
        } else {
          try await messaging.unsubscribe(fromTopic: MessagingTopic.auctionDidStart)
        }
        
      } catch { }
    }
  }
}
