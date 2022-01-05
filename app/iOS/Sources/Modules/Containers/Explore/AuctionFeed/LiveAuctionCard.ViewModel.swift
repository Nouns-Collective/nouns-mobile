//
//  LiveAuctionCard.ViewModel.swift
//  Nouns
//
//  Created by Ziad Tamim on 16.12.21.
//

import Foundation
import Services

extension LiveAuctionCard {
  
  class ViewModel: ObservableObject {
    @Published private(set) var auction: Auction
    @Published private(set) var title: String
    @Published private(set) var nounTrait: Seed
    @Published private(set) var nounBackground: String
    @Published private(set) var bidStatus: String
    @Published private(set) var lastBid: String
    @Published private(set) var remainingTime: String
    @Published private(set) var winner = ""
    /// Indicate whether the auction time is over.
    @Published private(set) var isWinnerAnounced = false
    
    private let localize = R.string.liveAuction.self
    private let composer: NounComposer
    
    init(
      auction: Auction,
      composer: NounComposer = AppCore.shared.nounComposer
    ) {
      self.auction = auction
      self.composer = composer
      
      title = R.string.explore.noun(auction.noun.id)
      nounTrait = auction.noun.seed
      isWinnerAnounced = auction.hasEnded
      
      let backgroundIndex = auction.noun.seed.background
      nounBackground = composer.backgroundColors[backgroundIndex]
      
      let amount = EtherFormatter.eth(from: auction.amount)
      lastBid = amount ?? R.string.shared.notApplicable()
      
      // On auction end, anounce the winner.
      if auction.hasEnded {
        bidStatus = localize.winningBid()
        winner = auction.bidder.id
        remainingTime = "00h:00m:00s"
      } else {
        // Calculating the time left for the auction to end.
        let timeLeft = Self.formatTimeLeft(auction)
        remainingTime = timeLeft ?? R.string.shared.notApplicable()
        bidStatus = localize.currentBid()
      }
    }
    
    private static func formatTimeLeft(_ auction: Auction) -> String? {
      guard let components = auction.components,
            let hour = components.hour,
            let minute = components.minute,
            let second = components.second
      else { return nil }
      
      return R.string.liveAuction.timeLeft(hour, minute, second)
    }
  }
}
