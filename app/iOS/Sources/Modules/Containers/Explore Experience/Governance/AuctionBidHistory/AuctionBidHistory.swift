//
//  BidHistoryView.swift
//  Nouns
//
//  Created by Ziad Tamim on 20.11.21.
//

import SwiftUI
import UIComponents
import Services

struct AuctionBidHistory: View {
  @StateObject var viewModel: ViewModel
  
  private let gridLayout = [
    GridItem(.flexible(), spacing: 20),
  ]
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      
      VStack(alignment: .leading, spacing: 10) {
        
        // Displays Noun's token.
        Text(viewModel.title)
          .font(.custom(.bold, size: 36))
        
        VPageGrid(viewModel.bids, columns: gridLayout, isLoading: viewModel.isLoading, shouldLoadMore: viewModel.shouldLoadMore, loadMoreAction: {
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
          .font(.custom(.bold, size: 36))
          .truncationMode(.middle)
        
        Spacer()
        
        Text(R.string.bidHistory.emptyState())
            .font(.custom(.medium, relativeTo: .headline))
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
          .font(.custom(.bold, size: 36))
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
