//
//  NotificationSection.swift
//  Nouns
//
//  Created by Ziad Tamim on 09.12.21.
//

import SwiftUI
import UIComponents

extension SettingsView {
  
  struct NotificationSection: View {
    @ObservedObject var viewModel: ViewModel
    
    private let localize = R.string.settings.self
    
    var body: some View {
      VStack {
        ToggleButton(
          localize.nounOclockNotificationTitle(),
          icon: .speaker,
          isOn: Binding(
            get: { viewModel.isNounOClockNotificationEnabled },
            set: { viewModel.setNounOClockNotification(isEnabled: $0) }
          )
        )
        
        ToggleButton(
          localize.newNounNotificationTitle(),
          icon: .speaker,
          isOn: Binding(
            get: { viewModel.isNewNounNotificationEnabled },
            set: { viewModel.setNewNounNotification(isEnabled: $0) }
          )
        )
        
        Text(localize.notificationNote())
          .font(.custom(.regular, relativeTo: .caption))
          .foregroundColor(Color.componentNounsBlack.opacity(0.6))
          .padding(.bottom, 10)
      }
      .task {
        await viewModel.refreshNotificationStates()
      }
    }
  }
}
