//
//  DialogInput.swift
//  Nouns
//
//  Created by Ziad Tamim on 23.11.21.
//

import SwiftUI
import UIComponents

/// Dialog to delete offline Nouns.
struct DeleteOfflineNounDialog: View {
  
  var body: some View {
    DialogNavigation(title: R.string.nounDeleteDialog.title()) {
      
      Text(R.string.nounDeleteDialog.message())
        .font(.custom(.regular, size: 17))
        .lineSpacing(6)
        .padding(.bottom, 20)
      
      SoftButton(
        text: R.string.nounDeleteDialog.nounDeleteAction(),
        largeAccessory: { Image.trash },
        color: Color.componentNounRaspberry,
        action: { },
        fill: [.width])
      
      SoftButton(
        text: R.string.nounDeleteDialog.nounCancelAction(),
        largeAccessory: { Image.smAbsent },
        action: { },
        fill: [.width])
    }
    .padding(16)
    .padding(.bottom, 4)
  }
}

///
struct NounMetadataDialog: View {
  @State var nounName: String
//  @Binding var isEditing: Bool
  @Binding var isPresented: Bool
  
  var body: some View {
    DialogNavigation(
      title: "Beets Battlestar Galactica",
      trailing: {
        SoftButton(
          icon: { Image.xmark },
          action: { isPresented.toggle() })
        
      },
      content: {
        NounDialogContent()
        NounDialogActions()
      })
      .padding(16)
      .padding(.bottom, 4)
  }
}

///
struct NounDialogContent: View {
  
  var body: some View {
    VStack(spacing: 20) {
      InfoCell(
        text: R.string.createNounDialog.nounBirthdayLabel("November 9, 2021"),
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
  
  var body: some View {
    SoftButton(
      text: R.string.createNounDialog.actionShare(),
      largeAccessory: { Image.share },
      action: { },
      fill: [.width])
    
    SoftButton(
      text: R.string.createNounDialog.actionSave(),
      largeAccessory: { Image.save },
      action: { },
      fill: [.width])
  }
}

/// 
struct NounOptionsActionSheet: View {
  @Binding var isPresented: Bool
  
  var body: some View {
    DialogNavigation(
      title: R.string.offchainNounActions.title(),
      leading: {
        
        SoftButton(
          icon: { Image.back },
          action: { isPresented.toggle() })
          .padding(.top, 5)
        
      },
      content: {
        
        SoftButton(
          text: R.string.offchainNounActions.play(),
          largeAccessory: { Image.playOutline },
          action: { },
          fill: [.width])
        
        SoftButton(
          text: R.string.offchainNounActions.edit(),
          largeAccessory: { Image.createOutline },
          action: { },
          fill: [.width])
        
        SoftButton(
          text: R.string.offchainNounActions.rename(),
          largeAccessory: { Image.rename },
          action: { },
          fill: [.width])
        
        SoftButton(
          text: R.string.offchainNounActions.delete(),
          largeAccessory: { Image.trash },
          color: Color.componentNounRaspberry,
          action: { },
          fill: [.width])
      })
  }
}

struct NounOptionsActionSheet_Previews: PreviewProvider {
  static var previews: some View {
    Text("OffChain Noun Actions")
      .bottomSheet(isPresented: .constant(true)) {
        NounOptionsActionSheet(
          isPresented: .constant(true))
      }
  }
}
