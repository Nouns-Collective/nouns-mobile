//
//  NotificationPermissionDialog.swift
//  Nouns
//
//  Created by Ziad Tamim on 11.02.22.
//

import SwiftUI
import NounsUI
import Services

extension View {
  
  func notificationPermissionDialog(isPresented: Binding<Bool>) -> some View {
    bottomSheet(isPresented: isPresented) {
      NotificationPermissionDialog(isPresented: isPresented)
    }
  }
}

/// An notification permission dialog for the initial `undetermined` state when asking for audio permission
/// With this sheet, users can choose to enable audio permissions (which then presents a standardized iOS audio permission dialog)
/// or choose to do it later, which dismisses the entire playground experience
struct NotificationPermissionDialog: View {
  @Binding var isPresented: Bool
  
  var body: some View {
    ActionSheet(
      icon: Image(R.image.bellNoun.name),
      title: R.string.notificationPermission.title()
    ) {
      
      Text(R.string.notificationPermission.body())
        .font(.custom(.regular, relativeTo: .subheadline))
        .lineSpacing(6)
        .padding(.bottom, 20)
      
      SoftButton(
        text: R.string.notificationPermission.enable(),
        largeAccessory: { Image.PointRight.standard },
        action: {
          withAnimation {
            AppCore.shared.analytics.logEvent(withEvent: AnalyticsEvent.Event.requestNotificationPermission,
                                              parameters: nil)
            setUpMessaging()
            isPresented.toggle()
          }
        })
        .controlSize(.large)
      
      SoftButton(
        text: R.string.notificationPermission.ignore(),
        largeAccessory: { Image.later },
        action: {
          withAnimation {
            isPresented.toggle()
          }
        })
        .controlSize(.large)
    }
    .padding(.bottom, 4)
  }
  
  private func setUpMessaging() {
    let messaging = AppCore.shared.messaging
    let settingsStore = AppCore.shared.settingsStore
    
    Task {
      // Requests APNs authorization.
      let enabled = try await messaging.requestAuthorization(
        UIApplication.shared,
        authorizationOptions: [.alert, .badge, .sound]
      )

      AppCore.shared.analytics.logEvent(withEvent: AnalyticsEvent.Event.setNotificationPermission,
                                        parameters: ["enabled": enabled])
      
      // Subscribe to topics on APNs registration.
      await settingsStore.setAllNotifications(isEnabled: true)

      for try await _ in messaging.notificationStateDidChange {
        settingsStore.syncMessagingTopicsSubscription()
      }
    }
  }
}
