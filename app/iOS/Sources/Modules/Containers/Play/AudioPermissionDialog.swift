//
//  AudioPermissionDialog.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2022-01-08.
//

import SwiftUI
import UIComponents

extension NounPlayground {
  
  struct AudioPermissionDialog: View {
    @ObservedObject var viewModel: ViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
      ActionSheet(
        title: R.string.audioPermissionDialog.title(),
        borderColor: nil
      ) {
        Text(R.string.audioPermissionDialog.body())
          .font(.custom(.regular, size: 17))
          .lineSpacing(6)
          .padding(.bottom, 20)
        
        SoftButton(
          text: R.string.audioPermissionDialog.enable(),
          largeAccessory: { Image.pointRight.standard },
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
}
