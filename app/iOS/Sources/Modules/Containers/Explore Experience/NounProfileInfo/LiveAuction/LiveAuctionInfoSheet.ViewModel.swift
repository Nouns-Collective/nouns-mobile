//
//  LiveAuctionInfoSheet.ViewModel.swift
//  Nouns
//
//  Created by Ziad Tamim on 16.12.21.
//

import Foundation
import Services

extension LiveAuctionInfoSheet {
  
  class ViewModel: ObservableObject {
    @Published private(set) var birthdate: String
    @Published private(set) var lastBid: String
    
    let auction: Auction
    
    init(auction: Auction) {
      self.auction = auction
      
      let amount = EtherFormatter.eth(from: auction.amount)
      lastBid = amount ?? R.string.shared.notApplicable()
      
      let startDate = Date(timeIntervalSince1970: auction.startTime)
      birthdate = R.string.nounProfile.birthday(startDate.formatted(dateStyle: .long))
    }
  }
}
