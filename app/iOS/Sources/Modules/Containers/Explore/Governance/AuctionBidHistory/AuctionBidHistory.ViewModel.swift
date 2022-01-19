//
//  AuctionBidHistory.ViewModel.swift
//  Nouns
//
//  Created by Ziad Tamim on 17.12.21.
//

import Foundation
import Services

extension AuctionBidHistory {
  
  class ViewModel: ObservableObject {
    let auction: Auction
    
    @Published var bids = [Bid]()
    @Published var isLoading = false
    @Published var shouldLoadMore = true
    
    private let pageLimit = 20
    private let service: OnChainNounsService
    
    /// Only show the empty placeholder when there are no bids and when the data source is not loading
    /// This occurs mainly on initial appearance, before any bids have loaded
    var isEmpty: Bool {
      bids.isEmpty && !isLoading
    }
    
    init(
      auction: Auction,
      service: OnChainNounsService = AppCore.shared.onChainNounsService
    ) {
      self.auction = auction
      self.service = service
    }
    
    var title: String {
      R.string.explore.noun(auction.noun.id)
    }
    
    @MainActor
    func fetchBidHistory() async {
      do {
        isLoading = true
        
        let bids = try await service.fetchBids(
          for: auction.noun.id,
             limit: pageLimit,
             after: bids.count
        )
        
        shouldLoadMore = bids.hasNext
        
        self.bids += bids.data
        
      } catch { }
      
      isLoading = false
    }
  }
}
