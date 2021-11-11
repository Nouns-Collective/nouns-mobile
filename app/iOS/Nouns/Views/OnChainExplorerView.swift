//
//  OnChainExplorerView.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import SwiftUI
import UIComponents

/// Housing view for exploring on chain nouns, including the current on-goign auction and previously auctioned nouns
struct OnChainExplorerView: View {
  @Namespace private var animation
  @State var selected: Int?
  @State var isNounDetailPresented: Bool = false
  @State var isPresentingActivity: Bool = false
  
  var body: some View {
    ZStack {
      LemonDrop()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
      
      ScrollView(.vertical, showsIndicators: false) {
        VStack(spacing: 20) {
          LiveAuctionCard(noun: "Noun 64")
          
          OnChainNounsView(animation: animation, selected: $selected, isPresentingActivity: $isPresentingActivity)
        }.padding(.horizontal, 20)
        .padding(.top, 60)
        .padding(.bottom, 40)
      }
      .ignoresSafeArea()
      .onChange(of: selected) { newValue in
        isNounDetailPresented = newValue != nil
      }
    }.sheet(isPresented: $isNounDetailPresented, onDismiss: {
      selected = nil
    }, content: {
      OnChainNounProfileView(isPresented: $isNounDetailPresented, noun: "Noun: \(selected ?? 0)", date: "Oct 11 1961", owner: "bob.eth")
    })
  }
}

struct OnChainExplorerView_Previews: PreviewProvider {
  static var previews: some View {
    OnChainExplorerView()
  }
}
