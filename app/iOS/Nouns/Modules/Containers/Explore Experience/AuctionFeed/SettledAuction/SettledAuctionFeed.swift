// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Ziad Tamim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import SwiftUI
import Services
import NounsUI

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
              .onWidgetOpen {
                if selectedAuction != nil {
                  selectedAuction = nil
                }
              }
          }
        )
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
              viewModel.loadAuctions()
            }
          )
          .padding(.bottom, 20)
        }
      }
      .onAppear {
        viewModel.loadAuctions()
        Task {
          await viewModel.listenSettledAuctionsChanges()
        }
      }
    }
  }
}
