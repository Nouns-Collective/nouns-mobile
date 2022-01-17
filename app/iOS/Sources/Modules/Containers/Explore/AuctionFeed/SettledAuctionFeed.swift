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
  
  @State private var selectedAuction: Auction?
  
  private let gridLayout = [
    GridItem(.flexible(), spacing: 20),
    GridItem(.flexible(), spacing: 20),
  ]
  
  var body: some View {
    VPageGrid(viewModel.auctions, columns: gridLayout, isLoading: viewModel.isFetching, shouldLoadMore: viewModel.shouldLoadMore, loadMoreAction: {
      // load next settled auctions batch.
      await viewModel.loadAuctions()
      
    }, placeholder: {
      // An activity indicator while loading auctions from the network.
      CardPlaceholder(count: viewModel.isInitiallyLoading ? 4 : 2)
      
    }, content: { auction in
      SettledAuctionCard(viewModel: .init(auction: auction))
        .onTapGesture {
          withAnimation(.spring()) {
            selectedAuction = auction
          }
        }
    })
      .task {
        await viewModel.watchNewlyAuctions()
      }
      // Presents more details about the settled auction.
      .fullScreenCover(item: $selectedAuction, onDismiss: {
        selectedAuction = nil
        
      }, content: { auction in
        NounProfileInfoCard(viewModel: .init(auction: auction))
      })
  }
}

/// Displays a settled auction along with the date it was created, the owner, and a status label.
struct SettledAuctionCard: View {
  @StateObject var viewModel: ViewModel
  
  var body: some View {
    StandardCard(
      header: viewModel.title,
      accessory: {
        Image.mdArrowCorner
      },
      media: {
        NounPuzzle(seed: viewModel.nounTraits)
          .background(Color(hex: viewModel.nounBackground))
      },
      content: {
        SafeLabel(
          viewModel.winnerBid,
          icon: Image.eth)
          .padding(.top, 8)
      })
      .headerStyle(.small)
  }
}
