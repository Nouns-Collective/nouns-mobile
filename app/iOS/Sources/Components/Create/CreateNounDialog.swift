//
//  DialogInput.swift
//  Nouns
//
//  Created by Ziad Tamim on 23.11.21.
//

import SwiftUI
import UIComponents

struct CreateNounDialog: View {
  @Binding var nounName: String
  @Binding var isEditing: Bool
  @Binding var isPresented: Bool
  
  private var input: some View {
    VStack {
      TextField(
        R.string.createNounDialog.inputPlaceholder(),
        text: $nounName)
        .font(.custom(.bold, size: 36))
      
      Divider()
        .frame(height: 2)
        .background(.black)
    }
  }
  
  private var titleItems: some View {
    HStack(alignment: .top) {
      Text("Beets Battlestar Galactica")
        .font(.custom(.bold, size: 36))
      
      Spacer()
      
      SoftButton(
        icon: { Image.xmark },
        action: { isPresented.toggle() })
        .padding(.top, 5)
    }
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      if isEditing {
        input
      } else {
        titleItems
      }
      
      VStack(spacing: 20) {
        InfoCell(
          text: R.string.createNounDialog.nounBirthdayLabel("November 9, 2021") ,
          icon: {
            Image.birthday
          })
        
        InfoCell(
          text: R.string.createNounDialog.ownerLabel(),
          icon: {
            Image.holder
          })
      }
      .padding(.bottom, 40)
      
      SoftButton(
        text: R.string.createNounDialog.actionShare(),
        largeAccessory: { Image.share },
        action: {
        },
        fill: [.width])
      
      SoftButton(
        text: R.string.createNounDialog.actionSave(),
        largeAccessory: { Image.save },
        action: {
        },
        fill: [.width])
    }
    .padding(16)
    .padding(.bottom, 4)
  }
}

struct CreateNounDialog_Previews: PreviewProvider {
  static var previews: some View {
    Text("")
      .bottomSheet(isPresented: .constant(true)) {
        CreateNounDialog(
          nounName: .constant(""),
          isEditing: .constant(true),
          isPresented: .constant(true))
      }
    
    Text("")
      .bottomSheet(isPresented: .constant(true)) {
        CreateNounDialog(
          nounName: .constant(""),
          isEditing: .constant(false),
          isPresented: .constant(true))
      }
  }
}
