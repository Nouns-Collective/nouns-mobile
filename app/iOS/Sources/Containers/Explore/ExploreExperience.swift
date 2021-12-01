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
struct ExploreExperience: View {
  @EnvironmentObject private var store: AppStore
  @State private var isAboutPresented = false
  
  private var isInitiallyLoading: Bool {
    store.state.auction.isLoading &&
    store.state.auction.auctions.isEmpty
  }
  
  var body: some View {
    NavigationView {
      ScrollView(.vertical, showsIndicators: false) {
        VStack(spacing: 20) {
          if let auction = store.state.auction.liveAuction {
            LiveAuctionCard(auction: auction)
          }
          
          SettledAuctionFeed()
        }
        .padding(.horizontal, 20)
        .softNavigationTitle(R.string.explore.title(), rightAccessory: {
          SoftButton(
            text: R.string.explore.about(),
            largeAccessory: { Image.about },
            action: {
              isAboutPresented.toggle()
            })
        })
      }
      .disabled(isInitiallyLoading)
      .background(Gradient.lemonDrop)
      .ignoresSafeArea()
    }
    .onAppear {
      store.dispatch(ListenLiveAuctionAction())
    }
    /// Presents about Nouns.wtf
    .fullScreenCover(isPresented: $isAboutPresented) {
      AboutView(isPresented: $isAboutPresented)
    }
  }
}

/// Displays Settled Auction Feed.
struct SettledAuctionFeed: View {
  @EnvironmentObject private var store: AppStore
  @State private var selection: Auction?
  
  private var isLoading: Bool {
    auctionState.isLoading && auctionState.auctions.isEmpty
  }
  
  private var auctionState: AuctionState {
    store.state.auction
  }
  
  private let gridLayout = [
    GridItem(.flexible(), spacing: 20),
    GridItem(.flexible(), spacing: 20),
  ]
  
  var body: some View {
    VPageGrid(
      auctionState.auctions,
      columns: gridLayout,
      loadMoreAction: loadMore(after:),
      placeholder: {
        CardPlaceholder(count: 2)
        
      }, content: { auction in
        SettledAuctionCard(auction: auction)
          .onTapGesture {
            withAnimation(.spring()) {
              selection = auction
            }
          }
      })
    /// Presents more details about the settled auction.
      .fullScreenCover(item: $selection, onDismiss: {
        selection = nil
        
      }, content: { auction in
        AuctionInfoView(auction: auction)
      })
  }
  
  private func loadMore(after index: Int) {
    store.dispatch(FetchAuctionsAction(after: index))
  }
}
