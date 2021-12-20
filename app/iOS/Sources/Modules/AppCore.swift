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
  
  let onChainNounsService: OnChainNounsService = TheGraphNounsProvider()
  let offChainNounsService: OffChainNounsService = CoreDataNounsProvider()
  let settingsStore = SettingsStore()
  
  lazy var nounComposer: NounComposer = {
    do {
      return try OfflineNounComposer.default()
    } catch {
      fatalError("Couldn't instantiate the NounComposer: \(error)")
    }
  }()
}
