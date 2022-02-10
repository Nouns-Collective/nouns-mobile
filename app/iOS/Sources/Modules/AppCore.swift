//
//  AppCore.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import Combine
import Services

final class AppCore {
  static let shared = AppCore()
  
  let crashReporting: CrashReporting = Crashlytics()
  let analytics: Analytics = FirebaseAnalytics()
  
  let onChainNounsService: OnChainNounsService = TheGraphOnChainNouns()
  let offChainNounsService: OffChainNounsService = CoreDataOffChainNouns()
  
  /// Service responsible for handling Apple Push Notifications.
  lazy var messaging: Messaging = FirebaseMessaging()
  
  /// User stored preference settings.
  lazy var settingsStore: SettingsStore = UserDefaultsSettingsStore(messaging: messaging)
  
  lazy var ensNameService: ENS = Web3ENSProvider()
  
  lazy var nounComposer: NounComposer = OfflineNounComposer.default()
}
