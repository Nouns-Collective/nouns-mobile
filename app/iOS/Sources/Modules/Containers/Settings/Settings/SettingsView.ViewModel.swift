//
//  SettingsView.ViewModel.swift
//  Nouns
//
//  Created by Ziad Tamim on 16.12.21.
//

import Foundation
import Services

extension SettingsView {
  
  class ViewModel: ObservableObject {
    
    /// Store where app configuration is persisted.
    private let settingsStore: SettingsStore
    
    init(settingsStore: SettingsStore = AppCore.shared.settingsStore) {
      self.settingsStore = settingsStore
    }
    
    var isNounOClockNotificationEnabled: Bool {
      get { settingsStore.isNounOClockNotificationEnabled }
      set { settingsStore.isNounOClockNotificationEnabled = newValue }
    }
    
    var isNewNounNotificationEnabled: Bool {
      get { settingsStore.isNewNounNotificationEnabled }
      set { settingsStore.isNewNounNotificationEnabled = newValue }
    }
  }
}
