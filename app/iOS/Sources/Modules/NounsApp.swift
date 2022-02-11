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
    setUpMessaging()
    
    return true
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) { }
  
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    
  }
}

// MARK: - Messaging

extension AppDelegate {
  
  func setUpMessaging() {
    
    let messaging = AppCore.shared.messaging
    let settingsStore = AppCore.shared.settingsStore
    // Subscribe to topics on APNs registration.
    messaging.onRegistrationCompletion = {
      settingsStore.syncMessagingTopicsSubscription()
    }
    
    Task {
      // Requests APNs authorization.
      _ = try await messaging.requestAuthorization(
        UIApplication.shared,
        authorizationOptions: [.alert, .badge, .sound]
      )
    }
  }
  
}
