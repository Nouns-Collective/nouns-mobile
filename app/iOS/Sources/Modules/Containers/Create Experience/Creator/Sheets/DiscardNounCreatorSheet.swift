//
//  DiscardNounCreatorSheet.swift
//  Nouns
//
//  Created by Ziad Tamim on 23.11.21.
//

import SwiftUI
import UIComponents

/// Dialog to delete offline Nouns.
extension NounCreator {
  
  /// A wrapper discard sheet, showing either a sheet to discard edit progress or
  /// creation progress based on the edit state of the view
  struct DiscardNounSheet: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
      if viewModel.isEditing {
        DiscardNounEditSheet(viewModel: viewModel)
      } else {
        DiscardNounCreationSheet(viewModel: viewModel)
      }
    }
  }
  
  /// A sheet presented when the user tries to cancel their progress
  /// while creating a new noun
  struct DiscardNounCreationSheet: View {
    @ObservedObject var viewModel: ViewModel
    
    @EnvironmentObject var bottomSheetManager: BottomSheetManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
      ActionSheet(
        title: R.string.nounDeleteDialog.title(),
        borderColor: nil
      ) {
        VStack(alignment: .leading) {
          Text(R.string.nounDeleteDialog.message())
            .font(.custom(.regular, relativeTo: .subheadline))
            .lineSpacing(6)
            .padding(.bottom, 20)
          
          SoftButton(
            text: R.string.nounDeleteDialog.nounDeleteAction(),
            largeAccessory: { Image.trash },
            color: Color.componentNounRaspberry,
            action: {
              bottomSheetManager.closeBottomSheet()
              dismiss()
            })
            .controlSize(.large)
          
          SoftButton(
            text: R.string.nounDeleteDialog.nounCancelAction(),
            largeAccessory: { Image.smAbsent },
            action: {
              withAnimation {
                viewModel.setMode(to: .creating)
              }
            })
            .controlSize(.large)
        }
      }
      .padding(.bottom, 4)
    }
  }
  
  /// A sheet presented when the user tries to cancel their progress
  /// while editing a pre-existing offline noun
  struct DiscardNounEditSheet: View {
    @ObservedObject var viewModel: ViewModel
    
    @EnvironmentObject var bottomSheetManager: BottomSheetManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
      ActionSheet(
        title: R.string.nounDiscardEditDialog.title(),
        borderColor: nil
      ) {
        VStack(alignment: .leading) {
          Text(R.string.nounDiscardEditDialog.message())
            .font(.custom(.regular, relativeTo: .subheadline))
            .lineSpacing(6)
            .padding(.bottom, 20)
          
          SoftButton(
            text: R.string.nounDiscardEditDialog.nounDeleteAction(),
            largeAccessory: { Image.trash },
            color: Color.componentNounRaspberry,
            action: {
              bottomSheetManager.closeBottomSheet()
              dismiss()
            })
            .controlSize(.large)
          
          SoftButton(
            text: R.string.nounDiscardEditDialog.nounCancelAction(),
            largeAccessory: { Image.smAbsent },
            action: {
              withAnimation {
                viewModel.setMode(to: .creating)
              }
            })
            .controlSize(.large)
        }
      }
      .padding(.bottom, 4)
    }
  }
}
