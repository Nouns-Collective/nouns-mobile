// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Ziad Tamim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
      return date.formatted(timeStyle: .short)
    }
  }
}
