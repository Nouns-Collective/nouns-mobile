//
//  ExploreExperience.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import SwiftUI
import UIComponents
import Services

/// Housing view for exploring on chain nouns, including the current on-goign auction and previously auctioned nouns
struct ExploreExperience: View {
  @EnvironmentObject private var store: AppStore
  
  private var isInitiallyLoading: Bool {
    (liveAuctionState.isLoading || settledAuctionsState.isLoading) &&
    settledAuctionsState.auctions.isEmpty
  }
  
  private var liveAuctionState: LiveAuctionState {
    store.state.auction.liveAuction
  }
  
  private var settledAuctionsState: SettledAuctionsState {
    store.state.auction.settledAuctions
  }
  
  var body: some View {
    NavigationView {
      ScrollView(.vertical, showsIndicators: false) {
        VStack(spacing: 20) {
          if let auction = liveAuctionState.auction {
            LiveAuctionCard(auction: auction)
          }
          
          SettledAuctionFeed()
        }
        .padding(.horizontal, 20)
        .softNavigationTitle(R.string.explore.title())
      }
      // Disable scrolling when data is initially loading.
      .disabled(isInitiallyLoading)
      .background(Gradient.lemonDrop)
      .ignoresSafeArea()
    }
    .onAppear {
      store.dispatch(ListenLiveAuctionAction())
    }
  }
}
