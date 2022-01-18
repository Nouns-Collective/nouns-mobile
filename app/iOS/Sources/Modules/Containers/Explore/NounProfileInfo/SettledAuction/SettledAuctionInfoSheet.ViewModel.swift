//
//  SettledAuctionInfoCard.ViewModel.swift
//  Nouns
//
//  Created by Ziad Tamim on 16.12.21.
//

import Foundation
import Services

extension SettledAuctionInfoSheet {
  
  class ViewModel: ObservableObject {
    @Published private(set) var winner: String
    @Published private(set) var birthdate: String
    @Published private(set) var winningBid: String
    @Published private(set) var nounProfileURL: URL?
    
    private let auction: Auction
    
    init(auction: Auction) {
      self.auction = auction
      
      winner = auction.noun.owner.id
      let amount = EtherFormatter.eth(from: auction.amount)
      winningBid = amount ?? R.string.shared.notApplicable()
      nounProfileURL = URL(string: "https://nouns.wtf/noun/\(auction.noun.id)")
      
      let startDate = Date(timeIntervalSince1970: auction.startTime)
      birthdate = R.string.nounProfile.birthday(startDate.formatted(dateStyle: .long))
    }
  }
}
