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

import SwiftUI
import NounsUI

extension SettingsView {
  
  struct NotificationSection: View {
    @Environment(\.scenePhase) var scenePhase
    
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
      // To update setting toggles everytime the app is reopened
      // This is useful if the user is on the Settings screen (this current screen)
      // and then goes to settings to turn on/off settings. Once they revisit the app
      // and are back on this screen, the toggles will update to match the new settings state
      .onChange(of: scenePhase == .active) { _ in
        Task {
          await viewModel.refreshNotificationStates()
        }
      }
    }
  }
}
