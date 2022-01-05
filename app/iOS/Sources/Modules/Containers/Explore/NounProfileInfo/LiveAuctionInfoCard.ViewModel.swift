//
//  LiveAuctionInfoCard.ViewModel.swift
//  Nouns
//
//  Created by Ziad Tamim on 16.12.21.
//

import Foundation
import Services

extension LiveAuctionInfoCard {
  
  class ViewModel: ObservableObject {
    @Published private(set) var birthdate: String
    @Published private(set) var lastBid: String
    @Published private(set) var remainingTime: String
    
    private let auction: Auction
    
    init(auction: Auction) {
      self.auction = auction
      
      let amount = EtherFormatter.eth(from: auction.amount)
      lastBid = amount ?? R.string.shared.notApplicable()
      
      remainingTime = Self.formatTimeLeft(auction) ?? R.string.shared.notApplicable()
      
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
