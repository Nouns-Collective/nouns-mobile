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
    
    @State private var newName: String
    
    init(viewModel: OffChainNounProfile.ViewModel) {
      self.viewModel = viewModel
      self.newName = viewModel.noun.name
    }

    var body: some View {
      ActionSheet(
        isEditing: true,
        placeholder: R.string.createNounDialog.inputPlaceholder(),
        text: $newName
      ) {

        // Saves Noun's changes.
        SoftButton(
          text: R.string.offchainNounActions.useName(),
          largeAccessory: { Image.save },
          action: {
            viewModel.didRename(newName)
            viewModel.isRenamePresented.toggle()
          }
        )
        .controlSize(.large)
        .padding(.top, 20)
        .disabled(newName.isEmpty)
        .actionSheetLeadingBarItem(id: "rename_action_sheet_close_button", content: {
          // Dismisses the presented sheet.
          SoftButton(icon: { Image.xmark }, action: {
            viewModel.isRenamePresented.toggle()
          })
        })
      }
    }
  }
}
