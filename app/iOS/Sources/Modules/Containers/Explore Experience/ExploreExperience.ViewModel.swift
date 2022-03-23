//
//  ExploreExperience.ViewModel.swift
//  Nouns
//
//  Created by Ziad Tamim on 16.12.21.
//

import Foundation
import Combine
import Services

extension ExploreExperience {
  
  class ViewModel: ObservableObject {
    private let service: OnChainNounsService
    
    init(service: OnChainNounsService = AppCore.shared.onChainNounsService) {
      self.service = service
    }
    
    // MARK: - Live Auction
    @Published var liveAuction: Auction?
    @Published var failedToLoadLiveAuction: Bool = false
    
    /// Boolean value to determine if both live auction and settled auctions are failing to load
    var failedToLoadExplore: Bool {
      failedToLoadLiveAuction && (failedToLoadSettledAuctions && auctions.isEmpty)
    }
    
    /// Listens to changes for the live auction's bid information and completion status
    @MainActor
    func listenLiveAuctionChanges() async {
      failedToLoadLiveAuction = false
      
      do {
        for try await auction in service.liveAuctionStateDidChange() {
          self.liveAuction = auction
        }
      } catch {
        failedToLoadLiveAuction = true
      }
    }
    
    // MARK: - Settled Auctions
    @Published var auctions = [Auction]()
    @Published var failedToLoadSettledAuctions: Bool = false
    @Published var shouldLoadMore: Bool = false
    @Published var isLoadingSettledAuctions: Bool = false
    
    private let pageLimit = 20
    
    /// A boolean to determine if the settled auctions are initially loading, defined
    /// by the loading state being `true` and for the settled auctions array `auctions` being empty
    var isInitiallyLoadingSettledAuctions: Bool {
      isLoadingSettledAuctions && auctions.isEmpty
    }
    
    /// A count of the number of settled auctions that have been loaded into the feed that aren't nounder-owned nouns.
    private var notNounderOwnedCount: Int {
      auctions.filter { $0.noun.isNounderOwned == false }.count
    }
    
    /// Watches for newly added settled auctions (whenever a live auction ends) and adds it to the feed
    @MainActor
    func watchNewlyAuctions() async {
      for await auction in service.settledAuctionsDidChange() {
        if !auctions.isEmpty && auctions.first?.id != auction.id {
          auctions.insert(auction, at: 0)
        }
      }
    }
    
    /// Loads settled auctions
    @MainActor
    func loadAuctions() {
      Task {
        failedToLoadSettledAuctions = false
        
        do {
          isLoadingSettledAuctions = true
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
          
        } catch {
          failedToLoadSettledAuctions = true
        }
        
        isLoadingSettledAuctions = false
      }
    }
  }
}
