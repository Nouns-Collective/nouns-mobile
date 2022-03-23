//
//  NotificationPermissionDialog.swift
//  Nouns
//
//  Created by Ziad Tamim on 11.02.22.
//

import SwiftUI
import UIComponents
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
      title: R.string.notificationPermission.title(),
      borderColor: nil
    ) {
      
      Text(R.string.notificationPermission.body())
        .font(.custom(.regular, size: 17))
        .lineSpacing(6)
        .padding(.bottom, 20)
      
      SoftButton(
        text: R.string.notificationPermission.enable(),
        largeAccessory: { Image.PointRight.standard },
        action: {
          withAnimation {
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
      // Subscribe to topics on APNs registration.
      for try await _ in messaging.notificationStateDidChange {
        settingsStore.syncMessagingTopicsSubscription()
      }
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
