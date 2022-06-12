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

extension NounPlayground {
  
  /// An audio permission dialog for the initial `undetermined` state when asking for audio permission
  /// With this sheet, users can choose to enable audio permissions (which then presents a standardized iOS audio permission dialog)
  /// or choose to do it later, which dismisses the entire playground experience
  struct AudioPermissionDialog: View {
    @ObservedObject var viewModel: ViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
      ActionSheet(
        title: R.string.audioPermissionDialog.title()
      ) {
        Text(R.string.audioPermissionDialog.body())
          .font(.custom(.regular, relativeTo: .subheadline))
          .lineSpacing(6)
          .padding(.bottom, 20)
        
        SoftButton(
          text: R.string.audioPermissionDialog.enable(),
          largeAccessory: { Image.PointRight.standard },
          action: {
            viewModel.requestMicrophonePermission()
          })
          .controlSize(.large)
        
        SoftButton(
          text: R.string.audioPermissionDialog.ignore(),
          largeAccessory: { Image.later },
          action: {
            withAnimation {
              // Dismisses the entire noun playground as it needs microphone access
              dismiss()
            }
          })
          .controlSize(.large)
      }
      .padding(.bottom, 4)
    }
  }
  
  /// An audio permission dialog for the `denied` and `restricted` state when asking for audio permission
  /// With this sheet, users will be directed to enable audio permissions by accessing the apps settings page in the Settings app
  /// or choose to do it later, which dismisses the entire playground experience
  struct AudioSettingsDialog: View {
    @ObservedObject var viewModel: ViewModel
    
    @Environment(\.openURL) var openURL
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
      ActionSheet(
        title: R.string.audioSettingsDialog.title()
      ) {
        Text(R.string.audioSettingsDialog.body())
          .font(.custom(.regular, relativeTo: .subheadline))
          .lineSpacing(6)
          .padding(.bottom, 20)
        
        SoftButton(
          text: R.string.audioSettingsDialog.enable(),
          largeAccessory: { Image.PointRight.standard },
          action: {
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
              openURL(settingsURL)
            }
          })
          .controlSize(.large)
        
        SoftButton(
          text: R.string.audioSettingsDialog.ignore(),
          largeAccessory: { Image.later },
          action: {
            withAnimation {
              // Dismisses the entire noun playground as it needs microphone access
              dismiss()
            }
          })
          .controlSize(.large)
      }
      .padding(.bottom, 4)
    }
  }
}
