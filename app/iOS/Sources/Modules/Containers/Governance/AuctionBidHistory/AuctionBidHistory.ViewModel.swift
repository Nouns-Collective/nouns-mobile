//
//  AuctionBidHistory.ViewModel.swift
//  Nouns
//
//  Created by Ziad Tamim on 17.12.21.
//

import Foundation
import Services

extension AuctionBidHistory {
  
  final class ViewModel: ObservableObject {
    let auction: Auction
    
    @Published var bids = [Bid]()
    @Published var isLoading = false
    
    private let pageLimit = 20
    private let onChainNounsService: OnChainNounsService
    
    init(
      auction: Auction,
      onChainNounsService: OnChainNounsService = AppCore.shared.onChainNounsService
    ) {
      self.auction = auction
      self.onChainNounsService = onChainNounsService
    }
    
    var title: String {
      R.string.explore.noun(auction.noun.id)
    }
    
    @MainActor
    func fetchBidHistory() {
      Task {
        do {
          bids += try await onChainNounsService.fetchBids(for: auction.noun.id, limit: pageLimit, after: bids.count)
        } catch { }
      }
    }
  }
}
