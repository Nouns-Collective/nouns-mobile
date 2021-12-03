//
//  SettledAuctionFeed.swift
//  Nouns
//
//  Created by Ziad Tamim on 01.12.21.
//

import SwiftUI
import Services
import UIComponents

/// Displays Settled Auction Feed.
struct SettledAuctionFeed: View {
  @EnvironmentObject private var store: AppStore
  @State private var selection: Auction?
  
  private var isLoading: Bool {
    settledAuctionsState.isLoading &&
    settledAuctionsState.auctions.isEmpty
  }
  
  private var settledAuctionsState: SettledAuctionsState {
    store.state.auction.settledAuctions
  }
  
  private let gridLayout = [
    GridItem(.flexible(), spacing: 20),
    GridItem(.flexible(), spacing: 20),
  ]
  
  var body: some View {
    VPageGrid(
      settledAuctionsState.auctions,
      columns: gridLayout,
      loadMoreAction: loadMore,
      placeholder: {
        // An activity indicator while loading auctions from the network.
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
        NounProfileInfoCard(auction: auction)
      })
  }
  
  private func loadMore() {
    let nextBatch = settledAuctionsState.auctions.count
    store.dispatch(FetchAuctionsAction(after: nextBatch))
  }
}

/// Displays a settled auction along with the date it was created, the owner, and a status label.
struct SettledAuctionCard: View {
  @Environment(\.nounComposer) private var nounComposer: NounComposer
  let auction: Auction
  
  var body: some View {
    StandardCard(
      media: {
        NounPuzzle(seed: auction.noun.seed)
          .background(Color(hex: nounComposer.backgroundColors[auction.noun.seed.background]))
      },
      smallHeader: R.string.explore.noun(auction.noun.id),
      accessoryImage: Image.mdArrowCorner,
      detail: {
        SafeLabel(
          EtherFormatter.eth(from: auction.amount) ?? R.string.shared.notApplicable(),
          icon: Image.eth)
      })
  }
}
