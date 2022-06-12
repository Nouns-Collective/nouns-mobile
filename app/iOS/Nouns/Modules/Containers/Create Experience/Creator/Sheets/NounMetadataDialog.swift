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

/// A dialog to present the current created noun's name (as a text field to allow the user to edit),
/// infromation such as birth date, and action to save the noun
extension NounCreator {
  
  struct NounMetadataDialog: View {
    @ObservedObject var viewModel: NounCreator.ViewModel
        
    var body: some View {
      ActionSheet(
        isEditing: true,
        placeholder: R.string.createNounDialog.inputPlaceholder(),
        text: $viewModel.nounName
      ) {
        VStack(alignment: .leading) {
          NounDialogContent()
          NounDialogActions(viewModel: viewModel)
        }
      }
      .padding(.bottom, 4)
    }
  }
  
  struct NounDialogContent: View {
    
    var body: some View {
      VStack(spacing: 20) {
        InfoCell(
          text: R.string.createNounDialog.nounBirthdayLabel(Date().formatted()),
          icon: { Image.birthday })
        
        InfoCell(
          text: R.string.createNounDialog.ownerLabel(),
          icon: { Image.holder })
      }
      .padding(.bottom, 40)
    }
  }
  
  ///
  struct NounDialogActions: View {
    @ObservedObject var viewModel: NounCreator.ViewModel

    @EnvironmentObject var bottomSheetManager: BottomSheetManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
      SoftButton(
        text: R.string.createNounDialog.actionSave(),
        largeAccessory: { Image.save },
        action: {
          viewModel.save()
          bottomSheetManager.closeBottomSheet()
          dismiss()
        }
      )
      .controlSize(.large)
      .disabled(viewModel.nounName.isEmpty)
    }
  }
}
