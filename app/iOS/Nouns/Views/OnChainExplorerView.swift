//
//  OnChainExplorerView.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import SwiftUI

/// <#Description#>
struct OnChainExplorerView: View {
  
  @State var selected: Int?
  
  var body: some View {
    ScrollView {
      VStack(spacing: 40) {
        LiveAuctionCard(noun: "Noun 64")
          .padding(.horizontal, -20)
        
        ForEach(0..<5) { num in
          if let selected = selected, selected == num {
            OnChainNounProfileCard(noun: "Noun \(num)", date: "Oct 11 2021", owner: "bob.eth")
              .padding(.horizontal, -20)
          } else {
            OnChainNounCard(noun: "Noun \(num)", date: "Oct 11 2021", owner: "bob.eth")
              .onTapGesture {
                withAnimation(.spring()) {
                  selected = num
                }
              }
          }
        }
      }
    }
  }
}

struct OnChainExplorerView_Previews: PreviewProvider {
  static var previews: some View {
    OnChainExplorerView()
  }
}
