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
    @Published var shouldLoadMore = true
    
    var isInitiallyLoading: Bool {
      isFetching && auctions.isEmpty
    }
    
    private let pageLimit = 20
    private var service: OnChainNounsService
    
    private var notNounderOwnedCount: Int {
      auctions.filter { $0.noun.isNounderOwned == false }.count
    }
    
    init(service: OnChainNounsService = AppCore.shared.onChainNounsService) {
      self.service = service
    }
    
    @MainActor
    func watchNewlyAuctions() async {
      for await auction in service.settledAuctionsDidChange() {
        if !auctions.isEmpty && auctions.first?.id != auction.id {
          auctions.insert(auction, at: 0)
        }
      }
    }
    
    @MainActor
    func loadAuctions() async {
      do {
        isFetching = true
        // Load next batch of the settled auctions from the network.
        // The cursor should be set to the amount of non-nounder owned
        // nouns in the view model as nounder owned nouns are not considered "auctions"
        let auctions = try await service.fetchAuctions(
          settled: true,
          includeNounderOwned: true,
          limit: pageLimit,
          cursor: notNounderOwnedCount
        )
        
        shouldLoadMore = auctions.hasNext
                        
        self.auctions += auctions.data
        
      } catch { }
      
      isFetching = false
    }
  }
}
