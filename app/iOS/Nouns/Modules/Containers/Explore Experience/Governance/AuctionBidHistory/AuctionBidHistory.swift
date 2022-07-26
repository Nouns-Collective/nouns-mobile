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
import NounsUI
import Services

struct AuctionBidHistory: View {
  @StateObject var viewModel: ViewModel
  
  private let gridLayout = [
    GridItem(.flexible(), spacing: 8),
  ]
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      
      VStack(alignment: .leading, spacing: 10) {
        
        // Displays Noun's token.
        Text(viewModel.title)
          .font(.custom(.bold, relativeTo: .title2))
        
        VPageGrid(viewModel.bids, columns: gridLayout, spacing: 10, isLoading: viewModel.isLoading, shouldLoadMore: viewModel.shouldLoadMore, loadMoreAction: {
          // load next bid history batch.
          await viewModel.fetchBidHistory()
          
        }, placeholder: {
          // An activity indicator while loading votes from the network.
          ActivityPlaceholder(count: 4)
          
        }, content: {
          BidRow(viewModel: .init(bid: $0))
        })
      }
      .padding()
      .ignoresSafeArea()
      
      if viewModel.failedToLoadMore {
        TryAgain(
          message: R.string.bidHistory.errorLoadMoreTitle(),
          buttonText: R.string.shared.tryAgain(),
          retryAction: {
            Task {
              await viewModel.fetchBidHistory()
            }
          }
        )
        .padding(.bottom, 80)
        .frame(maxWidth: .infinity, alignment: .center)
      }
    }
    .frame(maxWidth: .infinity)
    .ignoresSafeArea()
    .emptyPlaceholder(when: viewModel.isEmpty && !viewModel.failedToLoadMore, view: {
      BidHistoryEmptyView(viewModel: viewModel)
    })
    .emptyPlaceholder(when: viewModel.isEmpty && viewModel.failedToLoadMore, view: {
      BidHistoryErrorView(viewModel: viewModel)
    })
    .task {
      await viewModel.fetchBidHistory()
    }
  }
}

extension AuctionBidHistory {
  
  /// A view to display when there are no bids placed on this noun
  struct BidHistoryEmptyView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
      VStack(alignment: .leading, spacing: 10) {
        
        // Displays the owner token.
        Text(viewModel.title)
          .lineLimit(1)
          .font(.custom(.bold, relativeTo: .title2))
          .truncationMode(.middle)
        
        Spacer()
        
        Text(R.string.bidHistory.emptyState())
          .font(.custom(.regular, relativeTo: .footnote))
          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
          .padding()
          .opacity(0.6)
        
        Spacer()
      }
      .padding()
    }
  }
  
  /// A view to display when there was an error while retrieving a noun's bid history, resulting in 0 bids in the view model
  struct BidHistoryErrorView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
      VStack(alignment: .leading, spacing: 10) {
        
        // Displays the owner token.
        Text(viewModel.title)
          .lineLimit(1)
          .font(.custom(.bold, relativeTo: .title2))
          .truncationMode(.middle)
        
        Spacer()
        
        TryAgain(
          message: R.string.bidHistory.errorEmptyTitle(),
          buttonText: R.string.shared.tryAgain(),
          retryAction: {
            Task {
              await viewModel.fetchBidHistory()
            }
          }
        )
        .frame(maxWidth: .infinity, alignment: .center)
        
        Spacer()
      }
      .padding()
    }
  }
}
