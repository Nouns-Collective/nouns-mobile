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
