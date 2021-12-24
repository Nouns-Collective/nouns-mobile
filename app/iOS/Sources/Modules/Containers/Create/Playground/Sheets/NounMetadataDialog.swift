//
//  NounMetadataDialog.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-12-08.
//

import SwiftUI
import UIComponents

/// A dialog to present the current playground noun's name (as a text field to allow the user to edit),
/// infromation such as birth date, and action to save the noun
extension NounPlayground {
  
  struct NounMetadataDialog: View {
    @ObservedObject var viewModel: NounPlayground.ViewModel
        
    var body: some View {
      ActionSheet(
        title: "Beets Battlestar Galactica",
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
          text: R.string.createNounDialog.nounBirthdayLabel(DateFormatter.string(from: Date())),
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
    @ObservedObject var viewModel: NounPlayground.ViewModel

    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
      SoftButton(
        text: R.string.createNounDialog.actionSave(),
        largeAccessory: { Image.save },
        action: {
          viewModel.save()
          dismiss()
        })
        .controlSize(.large)
    }
  }
}
