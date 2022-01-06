//
//  NounProfileInfoCard.ViewModel.swift
//  Nouns
//
//  Created by Ziad Tamim on 16.12.21.
//

import Foundation
import Services

extension NounProfileInfoCard {
  
  class ViewModel: ObservableObject {
    @Published private(set) var title: String
    @Published private(set) var nounTraits: Seed
    @Published private(set) var isAuctionSettled: Bool
    @Published private(set) var nounProfileURL: URL?
    
    /// Indicate whether the auction time is over.
    @Published private(set) var isWinnerAnounced = false
    
    let auction: Auction
    
    init(auction: Auction) {
      self.auction = auction
      
      title = R.string.explore.noun(auction.noun.id)
      isAuctionSettled = auction.settled
      isWinnerAnounced = auction.hasEnded
      nounTraits = auction.noun.seed
      nounProfileURL = URL(string: "https://nouns.wtf/noun/\(auction.noun.id)")
    }
  }
}
