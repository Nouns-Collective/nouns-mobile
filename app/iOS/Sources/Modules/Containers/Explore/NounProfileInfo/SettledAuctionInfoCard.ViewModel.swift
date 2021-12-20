//
//  SettledAuctionInfoCard.ViewModel.swift
//  Nouns
//
//  Created by Ziad Tamim on 16.12.21.
//

import Foundation
import Services

extension SettledAuctionInfoCard {
  
  class ViewModel: ObservableObject {
    let auction: Auction
    
    init(auction: Auction) {
      self.auction = auction
    }
    
    /// The owner of the `Noun's`.
    var holder: String {
      auction.noun.owner.id
    }
    
    /// The date when the `Noun's` is settled.
    var birthdate: String {
      guard let timeInterval = Double(auction.startTime) else {
        return R.string.shared.notApplicable()
      }
      
      let date = Date(timeIntervalSince1970: timeInterval)
      return R.string.nounProfile.birthday(
        DateFormatter.string(from: date)
      )
    }
    
    /// `Noun's` winning bid.
    var winningBid: String {
      guard let amount = EtherFormatter.eth(from: auction.amount) else {
        return R.string.shared.notApplicable()
      }
      
      return amount
    }
    
    /// `Noun's Profile` External link .
    var nounProfileURL: URL? {
      URL(string: "https://nouns.wtf/noun/\(auction.noun.id)")
    }
  }
}
