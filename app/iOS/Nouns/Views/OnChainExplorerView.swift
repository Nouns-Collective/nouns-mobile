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
  
  @State var isPresentingActivity: Bool = false
  
  var body: some View {
    ZStack(alignment: .topTrailing) {
      ScrollViewReader { proxy in
        ScrollView(.vertical, showsIndicators: false) {
          VStack(spacing: 20) {
            LiveAuctionCard(noun: "Noun 64")
            
            OnChainNounsView(animation: animation, selected: $selected, isPresentingActivity: $isPresentingActivity)
          }.padding(.horizontal, 20)
          .padding(.top, 60)
          .padding(.bottom, 40)
        }
        .ignoresSafeArea()
        .background(Gradie)
        .onChange(of: selected) { newValue in
          if let newValue = newValue {
            withAnimation {
              proxy.scrollTo(newValue, anchor: .top)
            }
          }
        }
      }
      
      if selected != nil {
        SoftButton(systemImage: "xmark", action: {
          withAnimation(.spring()) {
            self.selected = nil
          }
        }).padding(.trailing, 20)
      }
    }.bottomSheet(isPresented: $isPresentingActivity) {
      NounderActivitiesSheet(isPresented: $isPresentingActivity)
        .padding(.bottom, 40)
    }
  }
}

struct OnChainExplorerView_Previews: PreviewProvider {
  static var previews: some View {
    OnChainExplorerView()
  }
}
