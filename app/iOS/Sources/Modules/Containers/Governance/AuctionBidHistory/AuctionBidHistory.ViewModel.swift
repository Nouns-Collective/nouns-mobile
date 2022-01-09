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
    
    private let pageLimit = 20
    private let service: OnChainNounsService
    
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
        bids += try await service.fetchBids(
          for: auction.noun.id,
             limit: pageLimit,
             after: bids.count
        )
        
      } catch { }
    }
  }
}
