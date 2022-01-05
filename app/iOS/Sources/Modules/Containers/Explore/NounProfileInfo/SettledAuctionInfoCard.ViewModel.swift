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
      
      if let startDate = Self.date(from: auction.startTime) {
        birthdate = R.string.nounProfile.birthday(startDate)
      } else {
        birthdate = R.string.shared.notApplicable()
      }
    }
    
    private static func date(from timeInterval: String) -> String? {
      guard let timeInterval = TimeInterval(timeInterval) else {
        return nil
      }
      
      let date = Date(timeIntervalSince1970: timeInterval)
      return DateFormatter.string(from: date)
    }
  }
}
