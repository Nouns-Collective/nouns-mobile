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
  @State var selectedAuction: Auction?
  @State var isNounProfilePresented: Bool = false
  @State var isPresentingNounActivity: Bool = false
  
  private var isInitiallyLoading: Bool {
    (store.state.onChainAuctions.isLoading || store.state.liveAuction.isLoading) && store.state.onChainAuctions.auctions.isEmpty
  }
  
  var body: some View {
    
    ScrollView(.vertical, showsIndicators: false) {
      VStack(spacing: 20) {
        if let auction = store.state.liveAuction.auction {
          LiveAuctionCard(auction: auction)
            .onTapGesture {
              selectedAuction = auction
            }
        } else {
          LiveAuctionPlaceholderCard()
            .loading()
        }
        
        OnChainNounsView(
          animation: animation,
          selected: $selectedAuction,
          isPresentingActivity: $isPresentingNounActivity)
      }
      .padding(.horizontal, 20)
      .padding(.top, 60)
      .padding(.bottom, 40)
    }
    .disabled(isInitiallyLoading)
    .background(Gradient.lemonDrop)
    .ignoresSafeArea()
    .onChange(of: selectedAuction) { newValue in
      isNounProfilePresented = newValue != nil
    }
    .onAppear {
      store.dispatch(FetchOnChainAuctionsAction())
      store.dispatch(ListenLiveAuctionAction())
    }
    .fullScreenCover(
      isPresented: $isNounProfilePresented,
      onDismiss: {
        selectedAuction = nil
      },
      content: {
        if let selectedAuction = selectedAuction {
          OnChainNounProfileView(
            isPresented: $isNounProfilePresented,
            auction: selectedAuction
          )
        }
      })
  }
}

struct OnChainExplorerView_Previews: PreviewProvider {
  static var previews: some View {
    OnChainExplorerView()
  }
}
