// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Mohammed Ibrahim
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
