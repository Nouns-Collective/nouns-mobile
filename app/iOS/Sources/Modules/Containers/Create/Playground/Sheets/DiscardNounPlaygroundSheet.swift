//
//  DiscardNounPlaygroundSheet.swift
//  Nouns
//
//  Created by Ziad Tamim on 23.11.21.
//

import SwiftUI
import UIComponents

/// Dialog to delete offline Nouns.
extension NounPlayground {
  
  struct DiscardNounPlaygroundSheet: View {
    @ObservedObject var viewModel: ViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
      ActionSheet(
        title: R.string.nounDeleteDialog.title(),
        borderColor: nil
      ) {
        VStack(alignment: .leading) {
          Text(R.string.nounDeleteDialog.message())
            .font(.custom(.regular, size: 17))
            .lineSpacing(6)
            .padding(.bottom, 20)
          
          SoftButton(
            text: R.string.nounDeleteDialog.nounDeleteAction(),
            largeAccessory: { Image.trash },
            color: Color.componentNounRaspberry,
            action: { dismiss() })
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
}
