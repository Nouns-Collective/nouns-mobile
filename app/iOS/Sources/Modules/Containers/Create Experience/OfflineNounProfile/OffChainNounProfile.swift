//
//  OffChainNounProfile.swift
//  Nouns
//
//  Created by Ziad Tamim on 28.11.21.
//

import SwiftUI
import UIComponents
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
        ShareSheet(activityItems: [image], imageMetadata: image,
                   titleMetadata: viewModel.noun.name)
      }
    }
  }
}
