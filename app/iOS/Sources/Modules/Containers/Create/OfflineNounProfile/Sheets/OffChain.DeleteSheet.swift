//
//  DeleteOfflineNounSheet.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-12-08.
//

import SwiftUI
import UIComponents

extension OffChainNounProfile {
 
  /// A sheet presented to offer a user the option to delete their created noun, or to cancel and keep it
  struct DeleteSheet: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: OffChainNounProfile.ViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
      ActionSheet(title: R.string.nounDeleteDialog.title()) {
        Text(R.string.nounDeleteDialog.message())
          .font(.custom(.regular, size: 17))
          .lineSpacing(6)
          .padding(.bottom, 20)
        
        /// Deletes the current Noun.
        SoftButton(
          text: R.string.nounDeleteDialog.nounDeleteAction(),
          largeAccessory: { Image.trash },
          color: Color.componentNounRaspberry,
          action: {
            withAnimation {
              // Dismisses the entire screen when the noun is deleted
              viewModel.deleteNoun()
              dismiss()
            }
          })
          .controlSize(.large)
        
        /// Dismisses the sheet.
        SoftButton(
          text: R.string.nounDeleteDialog.nounCancelAction(),
          largeAccessory: { Image.smAbsent },
          action: {
            withAnimation {
              isPresented.toggle()
            }
          })
          .controlSize(.large)
      }
      .padding(.bottom, 4)
    }
  }
}
