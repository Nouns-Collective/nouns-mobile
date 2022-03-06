//
//  GovernanceInfoView.swift
//  Nouns
//
//  Created by Ziad Tamim on 01.12.21.
//

import SwiftUI
import UIComponents

struct GovernanceInfoCard: View {
  @Binding var isPresented: Bool
  
  @State private var isSafariPresented = false
  
  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      HStack {
        Text(R.string.nounDAOInfo.title())
          .font(.custom(.bold, size: 36))
        
        Spacer()
        
        SoftButton(
          icon: { Image.xmark },
          action: {
            withAnimation {
              isPresented.toggle()
            }
          })
      }
      
      Text(R.string.nounDAOInfo.description())
        .font(.custom(.regular, size: 17))
        .lineSpacing(5)
      
      SoftButton(
        text: R.string.shared.learnMore(),
        smallAccessory: { Image.squareArrowDown },
        action: { isSafariPresented.toggle() })
        .controlSize(.large)
    }
    .padding()
    .padding(.bottom, 4)
    .fullScreenCover(isPresented: $isSafariPresented) {
      if let url = URL(string: R.string.shared.nounsWebsite()) {
        Safari(url: url)
      }
    }
  }
}
