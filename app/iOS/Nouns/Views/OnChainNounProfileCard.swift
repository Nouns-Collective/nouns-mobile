//
//  OnChainNounProfileCard.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import SwiftUI
import UIComponents

/// <#Description#>
struct OnChainNounProfileCard: View {
  
  let noun: String
  let date: String
  let owner: String
  let status: String = "Winner"
  
  var body: some View {
    StandardCard {
      Image("placeholder")
        .resizable()
        .aspectRatio(nil, contentMode: .fit)
    } label: {
      VStack {
        HStack(alignment: .center) {
          Text(noun)
            .font(.title)
            .fontWeight(.semibold)
          
          Spacer()
          
          Image(systemName: "rectangle.portrait.and.arrow.right")
        }
        
        VStack(alignment: .leading, spacing: 4) {
          Label("ETH Address", systemImage: "cpu")
          Label("Born on Oct 11 2021", systemImage: "gift")
          Label("Taken care of by bobby.eth", systemImage: "suit.heart")
        }.labelStyle(.titleAndIcon(spacing: 20))
          .padding(.top, 8)
          .frame(maxWidth: .infinity, alignment: .leading)
        
        HStack {
          PilledButton(systemImage: "square.and.arrow.up", text: "Share", action: {
            //
          }, appearance: .custom(color: Color.componentSoftGrey), fill: [.width])

          PilledButton(systemImage: "shuffle", text: "Remix", action: {
            //
          }, appearance: .custom(color: Color.componentSoftGrey), fill: [.width])
        }.padding(.top, 20)
      }
    }
  }
}

struct OnChainNounProfileCard_Previews: PreviewProvider {
  static var previews: some View {
    OnChainNounProfileCard(noun: "Noun 64", date: "Oct 11 2021", owner: "bobby.eth")
  }
}
