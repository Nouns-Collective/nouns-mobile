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
  
  /// A dialog to show more actions for a user's created noun, such as playing with the noun and editing/deleting
  struct MoreActionsDialog: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
      VStack(alignment: .leading, spacing: 10) {
        
        // Edit the noun.
        SoftButton(
          text: R.string.offchainNounActions.edit(),
          largeAccessory: { Image.createOutline },
          action: {
            viewModel.shouldShowNounCreator.toggle()
          })
          .controlSize(.large)
        
        // Rename the Noun.
        SoftButton(
          text: R.string.offchainNounActions.rename(),
          largeAccessory: { Image.rename },
          action: {
            viewModel.isRenamePresented.toggle()
          })
          .controlSize(.large)
        
        // Presents a confirmation sheet to delete the Noun.
        SoftButton(
          text: R.string.offchainNounActions.delete(),
          largeAccessory: { Image.trash },
          color: Color.componentNounRaspberry,
          action: {
            viewModel.isDeletePresented.toggle()
          })
          .controlSize(.large)
      }
      // Presents the playground with the current displayed noun.
      .fullScreenCover(isPresented: $viewModel.isPlayPresented) {
        NounPlayground(viewModel: .init(noun: viewModel.noun))
      }
      // Presents the noun creator to edit the current displayed noun
      .fullScreenCover(isPresented: $viewModel.shouldShowNounCreator) {
        NounCreator(
          viewModel: .init(
            initialSeed: viewModel.noun.seed,
            isEditing: true,
            didEditNoun: { seed in
              viewModel.didEdit(seed: seed)
            }
          ))
      }
    }
  }
}
