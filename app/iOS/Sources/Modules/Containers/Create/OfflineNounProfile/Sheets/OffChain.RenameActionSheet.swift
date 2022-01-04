//
//  RenameNounActionSheet.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-12-09.
//

import SwiftUI
import UIComponents

extension OffChainNounProfile {
 
  /// A sheet to present the user with a text field to edit the noun's name
  struct RenameActionSheet: View {
    
    @ObservedObject var viewModel: OffChainNounProfile.ViewModel

    var body: some View {
      ActionSheet(
        title: "Beets Battlestar Galactica",
        isEditing: true,
        placeholder: R.string.createNounDialog.inputPlaceholder(),
        borderColor: nil,
        text: $viewModel.noun.name
      ) {

        // Saves Noun's changes.
        SoftButton(
          text: R.string.offchainNounActions.useName(),
          largeAccessory: { Image.save },
          action: {
            viewModel.renameNoun()
            withAnimation {
              viewModel.isRenamePresented.toggle()
            }
          })
          .controlSize(.large)
          .padding(.top, 20)
          .actionSheetLeadingBarItem(content: {
            
            // Dismisses the presented sheet.
            SoftButton(icon: { Image.xmark }, action: {
              withAnimation {
                viewModel.isRenamePresented.toggle()
              }
            })
          })
      }
    }
  }
}
