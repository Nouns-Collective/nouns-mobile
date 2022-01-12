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
        
        VPageGrid(viewModel.bids, columns: gridLayout, isLoading: viewModel.isLoading, loadMoreAction: {
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
//      .ignoresSafeArea()
    }
//    .frame(maxWidth: .infinity)
//    .ignoresSafeArea()
//    .emptyPlaceholder(
//      condition: isEmpty,
//      message: R.string.bidHistory.emptyState()
//    )
//    .activityIndicator(isPresented: viewModel.isLoading)
//    .onAppear {
//      viewModel.fetchBidHistory()
//    }
  }
}
