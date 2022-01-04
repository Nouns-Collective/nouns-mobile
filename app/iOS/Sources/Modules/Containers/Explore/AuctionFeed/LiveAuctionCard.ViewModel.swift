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
    @Published var auction: Auction
//    @Published var isFetching = false
    @Published var remainingTime = R.string.shared.notApplicable()
    
    private let composer: NounComposer
    
    init(
      auction: Auction,
      composer: NounComposer = AppCore.shared.nounComposer
    ) {
      self.auction = auction
      self.composer = composer
      
      setUpAuctionTimer()
    }
    
    ///
    var title: String {
      R.string.explore.noun(auction.noun.id)
    }
    
    ///
    var currentBid: String {
      guard let amount = EtherFormatter.eth(from: auction.amount) else {
        return R.string.shared.notApplicable()
      }
      
      return amount
    }
    
    ///
    var nounSeed: Seed {
      auction.noun.seed
    }
    
    ///
    var nounBackground: String {
      let backgroundIndex = auction.noun.seed.background
      return composer.backgroundColors[backgroundIndex]
    }
    
    private func setUpAuctionTimer() {
      guard let components = auction.components,
            let hour = components.hour,
            let minute = components.minute,
            let second = components.second
      else { return }
      
      remainingTime = R.string.liveAuction.timeLeft(hour, minute, second)
    }
  }
}
