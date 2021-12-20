//
//  SettledAuctionFeed.ViewModel.swift
//  Nouns
//
//  Created by Ziad Tamim on 16.12.21.
//

import Foundation
import Services

extension SettledAuctionFeed {
  
  class ViewModel: ObservableObject {
    @Published var auctions = [Auction]()
    @Published var isFetching = false
    
    private let pageLimit = 20
    private var onChainNounsService: OnChainNounsService
    
    init(onChainNounsService: OnChainNounsService = AppCore.shared.onChainNounsService) {
      self.onChainNounsService = onChainNounsService
    }
    
    @MainActor
    func loadAuctions() {
      Task {
        do {
          isFetching = true
          
          // load next batch of the settled auctions from the network.
          auctions += try await onChainNounsService.fetchAuctions(
            settled: true,
            limit: pageLimit,
            cursor: auctions.count
          )
          
        } catch { }
        
        isFetching = false
      }
    }
  }
}

extension SettledAuctionCard {
  
  class ViewModel: ObservableObject {
    let auction: Auction
    
    init(auction: Auction) {
      self.auction = auction
    }
    
    var winnerBid: String {
      guard let bid = EtherFormatter.eth(
        from: auction.amount
      ) else {
        return R.string.shared.notApplicable()
      }
      
      return bid
    }
  }
}
