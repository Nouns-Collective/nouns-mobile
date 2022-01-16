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
  
  @StateObject var viewModel: ViewModel

  @Environment(\.dismiss) private var dismiss
  
  private enum SheetState: Int {
    case info
    case moreActions
  }
  
  @State private var sheetState: SheetState = .info
    
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
            tag: SheetState.info,
            title: viewModel.noun.name
          ) {
            dismiss()
          }
        
        // Displays various options to amend the built Noun.
        MoreActionsDialog(viewModel: viewModel)
          .actionSheetStackItem(
            tag: SheetState.moreActions,
            title: R.string.offchainNounActions.title()
          )
      }
      .padding(.bottom, 40)
      .padding(.horizontal, 20)
    }
    .bottomSheet(isPresented: $viewModel.isDeletePresented) {
      DeleteSheet(
        viewModel: viewModel
      )
    }
    // Sheet to rename the Noun.
    .bottomSheet(isPresented: $viewModel.isRenamePresented) {
      RenameActionSheet(
        viewModel: viewModel
      )
    }
    .background(GradientView(GradientColors.allCases[viewModel.noun.seed.background]))
    .sheet(isPresented: $viewModel.isShareSheetPresented) {
      if let imageData = viewModel.exportImageData, let image = UIImage(data: imageData) {
        ShareSheet(activityItems: [image], imageMetadata: image, titleMetadata: viewModel.noun.name)
      }
    }
  }
}

struct OffChainNounProfile_Previews: PreviewProvider {
  static var previews: some View {
    OffChainNounProfile(viewModel: .init(noun: Noun(name: "Test", owner: Account(), seed: Seed(background: 1, glasses: 2, head: 3, body: 4, accessory: 5))))
  }
}

extension OffChainNounProfile {

  struct NounExportImage: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
      NounPuzzle(seed: viewModel.noun.seed)
        .frame(width: 512, height: 512, alignment: .center)
        .background(GradientView(GradientColors.allCases[viewModel.noun.seed.background]))
    }
  }
}
