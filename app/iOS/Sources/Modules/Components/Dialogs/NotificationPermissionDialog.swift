//
//  NotificationPermissionDialog.swift
//  Nouns
//
//  Created by Ziad Tamim on 11.02.22.
//

import SwiftUI
import UIComponents

/// An notification permission dialog for the initial `undetermined` state when asking for audio permission
/// With this sheet, users can choose to enable audio permissions (which then presents a standardized iOS audio permission dialog)
/// or choose to do it later, which dismisses the entire playground experience
struct NotificationPermissionDialog: View {
  
  /// A closure to handle user action when it comes to enabling or disabling notification permission.
  var action: (_ shouldAuthorize: Bool) -> Void
  
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
            action(true)
          }
        })
        .controlSize(.large)
      
      SoftButton(
        text: R.string.notificationPermission.ignore(),
        largeAccessory: { Image.later },
        action: {
          withAnimation {
            action(false)
          }
        })
        .controlSize(.large)
    }
    .padding(.bottom, 4)
  }
}

struct NotificationPermissionDialog_previews: PreviewProvider {
  
  static var previews: some View {
    Text("Notifications")
      .bottomSheet(isPresented: .constant(true), content: {
        NotificationPermissionDialog { _ in }
      })
  }
}
