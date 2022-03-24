//
//  SettledAuctionFeed.swift
//  Nouns
//
//  Created by Ziad Tamim on 01.12.21.
//

import SwiftUI
import Services
import UIComponents

extension ExploreExperience {
  
  /// Displays Settled Auction Feed.
  struct SettledAuctionFeed: View {
    @ObservedObject var viewModel: ViewModel
    
    @State private var selectedAuction: Auction?
    
    private let gridLayout = [
      GridItem(.flexible(), spacing: 16),
      GridItem(.flexible(), spacing: 16),
    ]
    
    var body: some View {
      VStack {
        VPageGrid(
          viewModel.auctions,
          columns: gridLayout,
          isLoading: viewModel.isLoadingSettledAuctions,
          shouldLoadMore: viewModel.shouldLoadMore,
          loadMoreAction: {
            // load next settled auctions batch.
            await viewModel.loadAuctions()
          }, placeholder: {
            // An activity indicator while loading auctions from the network.
            CardPlaceholder(count: viewModel.isInitiallyLoadingSettledAuctions ? 4 : 2)
            
          }, content: { auction in
            SettledAuctionCard(viewModel: .init(auction: auction))
              .onTapGesture {
                withAnimation(.spring()) {
                  selectedAuction = auction
                }
              }
          }
        )
        .task {
          await viewModel.watchNewlyAuctions()
        }
        // Presents more details about the settled auction.
        .fullScreenCover(item: $selectedAuction, onDismiss: {
          selectedAuction = nil
          
        }, content: { auction in
          NounProfileInfo(viewModel: .init(auction: auction))
        })
        
        if viewModel.failedToLoadSettledAuctions {
          TryAgain(
            message: viewModel.auctions.isEmpty ? R.string.explore.settledErrorEmpty() : R.string.explore.settledErrorLoadMore(),
            buttonText: R.string.shared.tryAgain(),
            retryAction: {
              Task {
                await viewModel.loadAuctions()
              }
            }
          )
          .padding(.bottom, 20)
        }
      }
      .task {
        await viewModel.loadAuctions()
      }
    }
  }
}
