//
//  ActionSheet.swift
//  Nouns
//
//  Created by Ziad Tamim on 23.11.21.
//

import SwiftUI

import UIComponents

struct ActionSheet: View {
  @Binding var isPresented: Bool
  
  private var titleItems: some View {
    VStack(alignment: .leading) {
      SoftButton(
        icon: { Image.back },
        action: { isPresented.toggle() })
        .padding(.top, 5)
      
      Text(R.string.offchainNounActions.title())
        .font(.custom(.bold, size: 36))
    }
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 15) {
      titleItems
      
      SoftButton(
        text: R.string.offchainNounActions.play(),
        largeAccessory: { Image.playOutline },
        action: {
        },
        fill: [.width])
      
      SoftButton(
        text: R.string.offchainNounActions.edit(),
        largeAccessory: { Image.createOutline },
        action: {
        },
        fill: [.width])
      
      SoftButton(
        text: R.string.offchainNounActions.rename(),
        largeAccessory: { Image.rename },
        action: {
        },
        fill: [.width])
      
      SoftButton(
        text: R.string.offchainNounActions.delete(),
        largeAccessory: { Image.trash },
        color: Color.componentNounRaspberry,
        action: {
        },
        fill: [.width])
    }
    .padding(16)
    .padding(.bottom, 4)
  }
}

struct ActionSheet_Previews: PreviewProvider {
  static var previews: some View {
    Text("OffChain Noun Actions")
      .bottomSheet(isPresented: .constant(true)) {
        ActionSheet(
          isPresented: .constant(true))
      }
  }
}
