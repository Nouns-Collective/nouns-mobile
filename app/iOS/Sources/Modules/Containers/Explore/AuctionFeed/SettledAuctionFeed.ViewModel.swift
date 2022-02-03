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

extension SettledAuctionCard {
  
  class ViewModel: ObservableObject {
    /// The noun's ID.
    @Published private(set) var title: String
    
    /// The noun's traits.
    @Published private(set) var nounTraits: Seed
    
    /// The noun's background.
    @Published private(set) var nounBackground: String
    
    /// The winning bid on the settled auction.
    @Published private(set) var winnerBid: String
    
    /// The state to display the owner's domain on nounder noun.
    @Published private(set) var showENS = false
    
    /// The nounder token that owns the noun.
    @Published private(set) var nounderToken: String
    
    private let auction: Auction
    private let composer: NounComposer
    
    init(
      auction: Auction,
      composer: NounComposer = AppCore.shared.nounComposer
    ) {
      self.auction = auction
      self.composer = composer
      
      title = R.string.explore.noun(auction.noun.id)
      nounTraits = auction.noun.seed
      
      let bid = EtherFormatter.eth(from: auction.amount)
      winnerBid = bid ?? R.string.shared.notApplicable()
      
      let backgroundIndex = auction.noun.seed.background
      nounBackground = composer.backgroundColors[backgroundIndex]
      
      showENS = auction.noun.isNounderOwned
      nounderToken = auction.noun.owner.id
    }
  }
}
