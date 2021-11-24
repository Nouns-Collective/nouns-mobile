//
//  NounDeleteDialog.swift
//  Nouns
//
//  Created by Ziad Tamim on 23.11.21.
//

import SwiftUI
import UIComponents

struct NounDeleteDialog: View {
  @Binding var isPresented: Bool
  
  private var titleItems: some View {
    VStack(alignment: .leading, spacing: 15) {
      Text(R.string.nounDeleteDialog.title())
        .font(.custom(.bold, size: 36))
      
      Text(R.string.nounDeleteDialog.message())
        .font(.custom(.regular, size: 17))
        .lineSpacing(6)
    }
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 15) {
      titleItems
        .padding(.bottom, 20)
      
      SoftButton(
        text: R.string.nounDeleteDialog.nounDeleteAction(),
        largeAccessory: { Image.trash },
        color: Color.componentNounRaspberry,
        action: {
        },
        fill: [.width])
      
      SoftButton(
        text: R.string.nounDeleteDialog.nounCancelAction(),
        largeAccessory: { Image.smAbsent },
        action: {
        },
        fill: [.width])
    }
    .padding(16)
    .padding(.bottom, 4)
  }
}

struct NounDeleteDialog_Previews: PreviewProvider {
  static var previews: some View {
    Text("Noun delete dialog")
      .font(.custom(.medium, size: 20))
      .bottomSheet(isPresented: .constant(true)) {
        NounDeleteDialog(isPresented: .constant(true))
      }
  }
}
