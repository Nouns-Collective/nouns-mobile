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

extension SettledAuctionInfoSheet {
  
  class ViewModel: ObservableObject {
    @Published private(set) var winner: String
    @Published private(set) var birthdate: String
    @Published private(set) var winningBid: String
    @Published private(set) var showWinningBid: Bool
    @Published private(set) var showBirthdate: Bool
    @Published private(set) var governanceTitle: String
    @Published private(set) var domain: String?
    
    private let auction: Auction
    
    /// Holds a reference to the localized text.
    private let localize = R.string.nounProfile.self
    
    public var isNounderOwned: Bool {
      auction.noun.isNounderOwned
    }
    
    init(
      auction: Auction
    ) {
      self.auction = auction
      
      winner = auction.noun.owner.id
      let amount = EtherFormatter.eth(from: auction.amount)
      winningBid = amount ?? R.string.shared.notApplicable()
      
      let startDate = Date(timeIntervalSince1970: auction.startTime)
      birthdate = localize.birthday(startDate.formatted(dateStyle: .long))
      
      // Hide the winning bid on the nounders noun.
      showWinningBid = !auction.noun.isNounderOwned
      
      // TODO: Modify the nounders nouns retrieval logic to infer
      // the birthday from the previously auctioned noun.
      // Hide the birthday on the nounders noun as it isn't provided.
      showBirthdate = !auction.noun.isNounderOwned
      
      // On nounder noun, display activity as the only option.
      if auction.noun.isNounderOwned {
        governanceTitle = localize.auctionSettledGovernanceNounder()
      } else {
        governanceTitle = localize.auctionSettledGovernance()
      }
    }
  }
}
