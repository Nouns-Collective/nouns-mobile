//
//  GovernanceInfoView.swift
//  Nouns
//
//  Created by Ziad Tamim on 01.12.21.
//

import SwiftUI
import UIComponents

struct GovernanceInfoView: View {
  @Binding var isPresented: Bool
  
  @Environment(\.openURL) private var openURL
  
  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      HStack {
        Text(R.string.nounDAOInfo.title())
          .font(.custom(.bold, size: 36))
        
        Spacer()
        
        SoftButton(
          icon: { Image.xmark },
          action: { isPresented.toggle() })
      }
      
      Text(R.string.nounDAOInfo.description())
        .font(.custom(.regular, size: 17))
        .lineSpacing(5)
      
      SoftButton(
        text: R.string.shared.learnMore(),
        smallAccessory: { Image.squareArrowDown },
        action: {
          if let url = URL(string: "https://nouns.wtf") {
            openURL(url)
          }
        },
        fill: [.width])
    }
    .padding(16)
    .padding(.bottom, 4)
  }
}
