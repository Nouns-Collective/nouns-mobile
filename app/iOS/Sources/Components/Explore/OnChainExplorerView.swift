//
//  OnChainExplorerView.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import SwiftUI
import UIComponents
import Services

/// Housing view for exploring on chain nouns, including the current on-goign auction and previously auctioned nouns
struct OnChainExplorerView: View {
  @EnvironmentObject var store: AppStore
  
  @Namespace private var animation
  @State var selectedNoun: Noun?
  @State var isNounProfilePresented: Bool = false
  @State var isPresentingNounActivity: Bool = false
  
  var body: some View {
    
    ScrollView(.vertical, showsIndicators: false) {
      VStack(spacing: 20) {
        if store.state.liveAuction.isLoading {
          LiveAuctionPlaceholderCard()
            .loading()
        } else if let auction = store.state.liveAuction.auction {
          LiveAuctionCard(auction: auction)
        }
        
        OnChainNounsView(
          animation: animation,
          selected: $selectedNoun,
          isPresentingActivity: $isPresentingNounActivity)
      }
      .padding(.horizontal, 20)
      .padding(.top, 60)
      .padding(.bottom, 40)
    }
    .disabled(store.state.onChainNouns.isLoading || store.state.liveAuction.isLoading)
    .background(Gradient.lemonDrop)
    .ignoresSafeArea()
    .onChange(of: selectedNoun) { newValue in
      isNounProfilePresented = newValue != nil
    }
    .onAppear {
      store.dispatch(FetchOnChainNounsAction())
      store.dispatch(ListenLiveAuctionAction())
    }
    .sheet(
      isPresented: $isNounProfilePresented,
      onDismiss: {
        selectedNoun = nil
      },
      content: {
        if let selectedNoun = selectedNoun {
          OnChainNounProfileView(
            isPresented: $isNounProfilePresented,
            noun: selectedNoun)
        }
      })
  }
}

struct OnChainExplorerView_Previews: PreviewProvider {
  static var previews: some View {
    OnChainExplorerView()
  }
}
