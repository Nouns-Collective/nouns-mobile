//
//  AudioPermissionDialog.swift
//  Nouns
//
//  Created by Ziad Tamim on 11.02.22.
//

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
