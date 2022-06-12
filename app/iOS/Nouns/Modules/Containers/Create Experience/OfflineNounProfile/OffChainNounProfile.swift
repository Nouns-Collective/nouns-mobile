// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Ziad Tamim
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
import Services

/// A view to present the user's created noun, it's infromation, and edit options
struct OffChainNounProfile: View {
  
  private enum SheetMode: Int {
    case info
    case moreActions
  }
  
  @StateObject var viewModel: ViewModel
  
  /// A reference to dismiss the current presentation.
  @Environment(\.dismiss) private var dismiss
  
  /// Displays the current sheet mode with related options.
  @State private var sheetState: SheetMode = .info
  
  var body: some View {
    VStack(spacing: 0) {
      // Build & Display the Noun.
      NounPuzzle(seed: viewModel.noun.seed)
        .fixedSize(horizontal: false, vertical: !viewModel.isRenamePresented)
      
      ActionSheetStack(selection: $sheetState) {
        
        // Info sheet detailing the nouns name and creation information
        InfoSheetDialog(
          viewModel: viewModel,
          showMoreActions: {
            sheetState = .moreActions
          })
          .actionSheetStackItem(
            tag: SheetMode.info,
            title: viewModel.noun.name,
            exit: {
              dismiss()
            })
        
        // Displays various options to amend the built Noun.
        MoreActionsDialog(viewModel: viewModel)
          .actionSheetStackItem(
            tag: SheetMode.moreActions,
            title: R.string.offchainNounActions.title()
          )
      }
      .padding(.bottom, 40)
      .padding(.horizontal, 20)
    }
    .background(Gradient(NounCreator.backgroundColors[viewModel.noun.seed.background]))
    .ignoresSafeArea(.keyboard, edges: .bottom)
    .addBottomSheet()
    // Option to delete the current build progress.
    .bottomSheet(isPresented: $viewModel.isDeletePresented) {
      DeleteSheet(viewModel: viewModel)
    }
    // Option to rename the noun.
    .bottomSheet(isPresented: $viewModel.isRenamePresented) {
      RenameActionSheet(viewModel: viewModel)
    }
    // Option to share the built noun.
    .sheet(isPresented: $viewModel.isShareSheetPresented) {
      
      if let imageData = viewModel.exportImageData,
         let image = UIImage(data: imageData) {
        ShareSheet(activityItems: [image],
                   imageMetadata: image,
                   titleMetadata: R.string.offchainNounActions.shareMessage()
        )
        .onAppear(perform: viewModel.onShare)
      }
    }
    .onAppear {
      viewModel.onAppear()
    }
  }
}
