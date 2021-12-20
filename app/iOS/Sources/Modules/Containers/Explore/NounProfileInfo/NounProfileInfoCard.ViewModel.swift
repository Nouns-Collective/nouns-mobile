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
    let auction: Auction
    
    init(auction: Auction) {
      self.auction = auction
    }
    
    var title: String {
      R.string.explore.noun(auction.noun.id)
    }
    
    var isAuctionSettled: Bool {
      auction.settled
    }
    
    var nounProfileURL: URL? {
      URL(string: "https://nouns.wtf/noun/\(auction.noun.id)")
    }
  }
}
