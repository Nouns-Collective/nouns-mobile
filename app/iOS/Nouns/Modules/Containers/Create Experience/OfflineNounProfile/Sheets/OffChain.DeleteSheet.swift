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
