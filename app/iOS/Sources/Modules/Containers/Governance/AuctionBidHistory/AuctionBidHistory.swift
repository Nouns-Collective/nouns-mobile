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
  
  /// Only show the empty placeholder when there are no bids and when the data source is not loading
  /// This occurs mainly on initial appearance, before any bids have loaded
  private var isEmpty: Bool {
    viewModel.bids.isEmpty && !viewModel.isLoading
  }
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      
      VStack(alignment: .leading, spacing: 10) {
        
        // Displays Noun's token.
        Text(viewModel.title)
          .font(.custom(.bold, size: 36))
        
        VPageGrid(viewModel.bids, columns: gridLayout, loadMoreAction: {
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
    }
    .frame(maxWidth: .infinity)
    .ignoresSafeArea()
    .emptyPlaceholder(when: isEmpty, view: {
      BidHistoryEmptyView(viewModel: viewModel)
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
}
