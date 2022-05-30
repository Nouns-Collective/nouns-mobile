//
//  SettingsView.ViewModel.swift
//  Nouns
//
//  Created by Ziad Tamim on 16.12.21.
//

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
