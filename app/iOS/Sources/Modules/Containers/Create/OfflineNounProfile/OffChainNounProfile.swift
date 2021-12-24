//
//  OffChainNounProfile.swift
//  Nouns
//
//  Created by Ziad Tamim on 28.11.21.
//

import SwiftUI
import UIComponents

/// A view to present the user's created noun, it's infromation, and edit options
struct OffChainNounProfile: View {
  @StateObject var viewModel: ViewModel
  
  @State private var isRenamePresented = false
  @State private var isDeletePresented = false
  @Environment(\.dismiss) private var dismiss
  
  // TODO: - What is it for?
  @State private var selected: Int = 0
  
  var body: some View {
    VStack(spacing: 0) {
      // Build & Display the Noun.
      NounPuzzle(seed: viewModel.noun.seed)
      
      ActionSheetStack(selection: $selected) {
        
        InfoSheetDialog(
          viewModel: viewModel,
          showMoreActions: {
            selected = 1
          })
          .actionSheetStackItem(
            tag: 0,
            title: viewModel.noun.name
          ) {
            dismiss()
          }
        
        // Displays various options to amend the built Noun.
        MoreActionsDialog(
          isRenameActionPresented: $isRenamePresented,
          isDeleteActionPresented: $isDeletePresented
        ).actionSheetStackItem(
          tag: 1,
          title: R.string.offchainNounActions.title()
        )
      }
      .padding(.bottom, 40)
      .padding(.horizontal, 20)
    }
    .bottomSheet(isPresented: $isDeletePresented) {
      DeleteSheet(
        isPresented: $isDeletePresented,
        viewModel: viewModel
      )
    }
    // Sheet to rename the Noun.
    .bottomSheet(isPresented: $isRenamePresented) {
      RenameActionSheet(
        isPresented: $isRenamePresented,
        viewModel: viewModel
      )
    }
    .background(Gradient.blueberryJam)
  }
}
