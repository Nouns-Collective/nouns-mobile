//
//  OfflineNounInformationSheetDialog.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-12-08.
//

import SwiftUI
import UIComponents

extension OffChainNounProfile {
  
  /// A dialog to present the information of a user's created noun (such as the created date) and options to edit or share
  struct InfoSheetDialog: View {
    
    let viewModel: OffChainNounProfile.ViewModel
    let showMoreActions: () -> Void
    
    init(
      viewModel: OffChainNounProfile.ViewModel,
      showMoreActions: @escaping () -> Void
    ) {
      self.viewModel = viewModel
      self.showMoreActions = showMoreActions
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
              let imageData = NounExportImage(viewModel: viewModel).asImageData()
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
