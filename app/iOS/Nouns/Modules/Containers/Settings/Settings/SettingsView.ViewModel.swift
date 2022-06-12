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
import Services
import UIKit.UIApplication

extension SettingsView {
  
  final class ViewModel: ObservableObject {
    
    @Published var isNotificationPermissionTutorialPresented = false
    
    /// A boolean to indicate whether the notification permission
    /// dialog is presented only on `notDetermined` state.
    @Published var isNotificationPermissionDialogPresented = false
    
    @Published var isNounOClockNotificationEnabled = false
    
    @Published var isNewNounNotificationEnabled = false
    
    /// Store where app configuration is persisted.
    private var settingsStore: SettingsStore
    private let messaging: Messaging
    
    init(
      messaging: Messaging = FirebaseMessaging(),
      settingsStore: SettingsStore = AppCore.shared.settingsStore
    ) {
      self.messaging = messaging
      self.settingsStore = settingsStore
      
      Task {
        for try await _ in messaging.notificationStateDidChange {
          await refreshNotificationStates()
        }
      }
    }
    
    // MARK: - Notifications
    
    func setNounOClockNotification(isEnabled: Bool) {
      Task {
        guard case .authorized = await messaging.authorizationStatus else {
          await handleNotificationPermission()
          return
        }
        
        await settingsStore.setNounOClockNotification(isEnabled: isEnabled)
        await refreshNotificationStates()
        AppCore.shared.analytics.logEvent(
          withEvent: AnalyticsEvent.Event.setNounOClockNotificationPermission,
          parameters: ["enabled": isEnabled])
      }
    }
    
    func setNewNounNotification(isEnabled: Bool) {
      Task {
        guard case .authorized = await messaging.authorizationStatus else {
          await handleNotificationPermission()
          return
        }

        await settingsStore.setNewNounNotification(isEnabled: isEnabled)
        await refreshNotificationStates()
        AppCore.shared.analytics.logEvent(
          withEvent: AnalyticsEvent.Event.setNewNounNotificationPermission,
          parameters: ["enabled": isEnabled])
      }
    }
    
    @MainActor
    func refreshNotificationStates() async {
      isNounOClockNotificationEnabled = await settingsStore.isNounOClockNotificationEnabled
      isNewNounNotificationEnabled = await settingsStore.isNewNounNotificationEnabled
    }
    
    @MainActor
    private func handleNotificationPermission() async {
      switch await messaging.authorizationStatus {
      case .denied:
        isNotificationPermissionTutorialPresented.toggle()
        
      case .notDetermined:
        isNotificationPermissionDialogPresented.toggle()
        
      default:
        break
      }
    }

    func onAppear() {
      AppCore.shared.analytics.logScreenView(withScreen: AnalyticsEvent.Screen.settings)
    }
  }
}
