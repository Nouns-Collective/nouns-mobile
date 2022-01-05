//
//  BidRow.ViewModel.swift
//  Nouns
//
//  Created by Ziad Tamim on 17.12.21.
//

import Foundation
import Services

extension BidRow {
  
  class ViewModel: ObservableObject {
    let bid: Bid
    
    init(bid: Bid) {
      self.bid = bid
    }
    
    var bidderIdentifier: String {
      bid.bidder.id
    }
    
    var bidAmount: String {
      guard let amount = EtherFormatter.eth(from: bid.amount) else {
        return R.string.shared.unavailable()
      }
    
      return amount
    }
    
    var bidDate: String {
      guard let timeInterval = Double(bid.blockTimestamp) else {
        return R.string.bidHistory.blockUnavailable()
      }
      
      let date = Date(timeIntervalSince1970: timeInterval)
      return DateFormatter.string(from: date, timeStyle: .short)
    }
  }
}
