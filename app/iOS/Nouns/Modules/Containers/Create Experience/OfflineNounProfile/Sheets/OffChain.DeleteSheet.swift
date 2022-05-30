//
//  DeleteOfflineNounSheet.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-12-08.
//

import SwiftUI
import NounsUI

extension OffChainNounProfile {
 
  /// A sheet presented to offer a user the option to delete their created noun, or to cancel and keep it
  struct DeleteSheet: View {
    
    @ObservedObject var viewModel: OffChainNounProfile.ViewModel
    @EnvironmentObject var bottomSheetManager: BottomSheetManager
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
      ActionSheet(
        title: R.string.nounDeleteDialog.title()
      ) {
        Text(R.string.nounDeleteDialog.message())
          .font(.custom(.regular, relativeTo: .subheadline))
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
              bottomSheetManager.closeBottomSheet()
              dismiss()
            }
          })
          .controlSize(.large)
        
        /// Dismisses the sheet.
        SoftButton(
          text: R.string.nounDeleteDialog.nounCancelAction(),
          largeAccessory: { Image.later },
          action: {
            withAnimation {
              viewModel.isDeletePresented.toggle()
            }
          })
          .controlSize(.large)
      }
      .padding(.bottom, 4)
    }
  }
}
