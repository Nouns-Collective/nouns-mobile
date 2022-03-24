//
//  AppCore.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import Combine
import Services
import UIComponents

final class AppCore {
  static let shared = AppCore()
  
  let crashReporting: CrashReporting = Crashlytics()
  let analytics: Analytics = FirebaseAnalytics()
  
  let onChainNounsService: OnChainNounsService = TheGraphOnChainNouns()
  let offChainNounsService: OffChainNounsService = CoreDataOffChainNouns()
  let nounComposer: NounComposer = OfflineNounComposer.default()

  /// A service to extract the eth domain from the network.
  let ensNameService: ENS = Web3ENSProvider()
  
  /// Service responsible for handling Apple Push Notifications.
  let messaging: Messaging = FirebaseMessaging()
  
  /// User stored preference settings.
  lazy var settingsStore: SettingsStore = UserDefaultsSettingsStore(messaging: messaging)
  
}
