//
//  OfflineNounMoreActionsDialog.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-12-08.
//

import SwiftUI
import UIComponents

extension OffChainNounProfile {
  
  /// A dialog to show more actions for a user's created noun, such as playing with the noun and editing/deleting
  struct MoreActionsDialog: View {
    
    @ObservedObject var viewModel: ViewModel
        
    var body: some View {
      VStack(alignment: .leading, spacing: 10) {
        // Switches to the play experience using the built Noun.
        SoftButton(
          text: R.string.offchainNounActions.play(),
          largeAccessory: { Image.playOutline },
          action: { })
          .controlSize(.large)
        
        //
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
            withAnimation {
              viewModel.isRenamePresented.toggle()
            }
          })
          .controlSize(.large)
        
        // Presents a confirmation sheet to delete the Noun.
        SoftButton(
          text: R.string.offchainNounActions.delete(),
          largeAccessory: { Image.trash },
          color: Color.componentNounRaspberry,
          action: {
            withAnimation {
              viewModel.isDeletePresented.toggle()
            }
          })
          .controlSize(.large)
      }
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
