//
//  LiveAuctionInfoCard.ViewModel.swift
//  Nouns
//
//  Created by Ziad Tamim on 16.12.21.
//

import Foundation
import Services

extension LiveAuctionInfoCard {
  
  @MainActor
  class ViewModel: ObservableObject {
    @Published var remainingTime = R.string.shared.notApplicable()
    
    let auction: Auction
    
    init(auction: Auction) {
      self.auction = auction
      
      setUpAuctionTimer()
    }
    
    var birthdate: String {
      guard let timeInterval = Double(auction.startTime) else {
        return R.string.shared.notApplicable()
      }
      
      let date = Date(timeIntervalSince1970: timeInterval)
      return R.string.nounProfile.birthday(DateFormatter.string(from: date))
    }
    
    var lastBid: String {
      guard let amount = EtherFormatter.eth(
        from: auction.amount
      ) else {
        return R.string.shared.notApplicable()
      }
      
      return amount
    }
    
    /// Update the remaining time.
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
