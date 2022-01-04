//
//  NounsApp.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-09-28.
//

import SwiftUI
import UIComponents
import Services

struct NounComposerKey: EnvironmentKey {
  static var defaultValue: NounComposer = AppCore.shared.nounComposer
}

extension EnvironmentValues {
  
  var nounComposer: NounComposer {
    get { self[NounComposerKey.self] }
    set { self[NounComposerKey.self] = newValue }
  }
}

@main
struct NounsApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  private var nounComposer = AppCore.shared.nounComposer
  
  init() {
    UIComponents.configure()
  }
  
  var body: some Scene {
    WindowGroup {
      RouterView()
        .environment(\.nounComposer, nounComposer)
        .preferredColorScheme(.light)
    }
  }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    
    // Set up remote notifications.
    Task { await setUpMessaging() }
    
    return true
  }
  
}

// MARK: - Messaging

extension AppDelegate {
  
  @MainActor
  func setUpMessaging() async {
    do {
      let messaging = AppCore.shared.messaging
      let settingsStore = AppCore.shared.settingsStore
      // Subscribe to topics on APNs registration.
      messaging.setTokenHandler = { [weak self, weak messaging] in
        guard let messaging = messaging else { return }
        
        try await self?.subscribe(to: messaging, settingsStore: settingsStore)
      }
      
      // Requests APNs authorization.
      _ = try await messaging.appAuthorization(
        UIApplication.shared,
        authorizationOptions: [.alert, .badge, .sound]
      )
      
    } catch {
      print("Couldn't grant authorization: ", error)
    }
  }
  
  private func subscribe(to messaging: Messaging, settingsStore: SettingsStore) async throws {
    if settingsStore.isNounOClockNotificationEnabled {
      try await messaging.subscribe(toTopic: "auction_will_end")
    }
    
    if settingsStore.isNewNounNotificationEnabled {
      try await messaging.subscribe(toTopic: "auction_did_start")
    }
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) { }
  
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) { }
}
