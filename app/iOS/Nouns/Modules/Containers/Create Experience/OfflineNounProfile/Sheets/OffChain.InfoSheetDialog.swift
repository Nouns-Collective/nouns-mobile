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
  
  /// A dialog to present the information of a user's created noun (such as the created date) and options to edit or share
  struct InfoSheetDialog: View {
    
    let viewModel: OffChainNounProfile.ViewModel
    private let showMoreActions: () -> Void
    
    init(
      viewModel: OffChainNounProfile.ViewModel,
      showMoreActions: @escaping () -> Void
    ) {
      self.viewModel = viewModel
      self.showMoreActions = showMoreActions
    }
    
    /// A view that displays the created name to be exported and shared.
    ///
    /// - Returns: This view contains the created noun with background.
    private var nounExportView: some View {
      NounPuzzle(seed: viewModel.noun.seed)
        .frame(width: 512, height: 512, alignment: .center)
        .background(Gradient(NounCreator.backgroundColors[viewModel.noun.seed.background]))
    }
    
    var body: some View {
      VStack(alignment: .leading, spacing: 20) {
        VStack(spacing: 20) {
          InfoCell(
            text: R.string.createNounDialog.nounBirthdayLabel(viewModel.nounBirthdate),
            icon: { Image.birthday })
          
          InfoCell(
            text: R.string.createNounDialog.ownerLabel(),
            icon: { Image.holder })
        }
        .padding(.bottom, 40)
        
        VStack(spacing: 10) {
          // Share the Noun's image.
          SoftButton(
            text: R.string.createNounDialog.actionShare(),
            largeAccessory: { Image.share },
            action: {
              // Builds the view and generates the image
              // before the share sheet is presented
              // to ensure a blank image is not returned
              let imageData = nounExportView.asImageData()
              viewModel.exportImageData = imageData
              viewModel.isShareSheetPresented.toggle()
            })
            .controlSize(.large)
          
          SoftButton(
            text: R.string.offchainNounActions.title(),
            smallAccessory: { Image.mdArrowRight },
            action: {
              withAnimation {
                showMoreActions()
              }
            })
            .controlSize(.large)
        }
      }
    }
  }
}
