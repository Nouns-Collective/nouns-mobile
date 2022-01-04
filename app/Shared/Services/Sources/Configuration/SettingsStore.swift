//
//  SettingsStore.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-12-06.
//

import Foundation
import SwiftUI

/// A class to store, read, and update UserDefault values
public struct SettingsStore {
  
  /// A boolean value to determine whether the user has seen and completed with the onboarding experience (on first launch).
  @AppStorage("hasCompletedOnboarding") public var hasCompletedOnboarding = true
  
  /// A boolean value to determine whether the user has enabled APNs for `Noun O'Clock`.
  @AppStorage("isNounOClockNotificationEnabled") public var isNounOClockNotificationEnabled = true
  
  /// A boolean value to determine whether the user has enabled APNs for `New Noun`.
  @AppStorage("isNewNounNotificationEnabled") public var isNewNounNotificationEnabled = true
  
  public init() { }
}
