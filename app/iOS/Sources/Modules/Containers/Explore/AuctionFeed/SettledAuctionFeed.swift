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
  @StateObject var viewModel = SettledAuctionFeed.ViewModel()
  
  @State private var selection: Auction?
  
  private let gridLayout = [
    GridItem(.flexible(), spacing: 20),
    GridItem(.flexible(), spacing: 20),
  ]
  
  var body: some View {
    VPageGrid(viewModel.auctions, columns: gridLayout, loadMoreAction: {
      // load next settled auctions batch.
      viewModel.loadAuctions()
      
    }, placeholder: {
      // An activity indicator while loading auctions from the network.
      CardPlaceholder(count: 2)
      
    }, content: { auction in
      SettledAuctionCard(viewModel: .init(auction: auction))
        .onTapGesture {
          withAnimation(.spring()) {
            selection = auction
          }
        }
    })
    // Presents more details about the settled auction.
      .fullScreenCover(item: $selection, onDismiss: {
        selection = nil
        
      }, content: { auction in
        NounProfileInfoCard(viewModel: .init(auction: auction))
      })
  }
}

/// Displays a settled auction along with the date it was created, the owner, and a status label.
struct SettledAuctionCard: View {
  @StateObject var viewModel: ViewModel
  
  @Environment(\.nounComposer) private var nounComposer: NounComposer
  
  var body: some View {
    StandardCard(
      header: R.string.explore.noun(viewModel.auction.noun.id),
      accessory: {
        Image.mdArrowCorner
      },
      media: {
        NounPuzzle(seed: viewModel.auction.noun.seed)
          .background(Color(hex: nounComposer.backgroundColors[viewModel.auction.noun.seed.background]))
      },
      content: {
        SafeLabel(
          R.string.explore.noun(viewModel.auction.noun.id),
          icon: Image.eth)
          .padding(.top, 8)
      })
      .headerStyle(.small)
  }
}
