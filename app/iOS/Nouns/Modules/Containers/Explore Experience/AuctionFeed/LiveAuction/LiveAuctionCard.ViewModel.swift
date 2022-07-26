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

extension LiveAuctionCard {
  
  class ViewModel: ObservableObject {
    @Published private(set) var auction: Auction
    @Published private(set) var title: String
    @Published private(set) var nounTrait: Seed
    @Published private(set) var nounBackground: String
    @Published private(set) var bidStatus: String
    @Published private(set) var lastBid: String
    @Published private(set) var winner = ""
    /// Indicate whether the auction time is over.
    @Published private(set) var isWinnerAnnounced = false
    
    private let composer: NounComposer
    
    /// Holds a reference to the localized text.
    private let localize = R.string.liveAuction.self
    
    init(
      auction: Auction,
      composer: NounComposer = AppCore.shared.nounComposer
    ) {
      self.auction = auction
      self.composer = composer
      
      title = R.string.explore.noun(auction.noun.id)
      nounTrait = auction.noun.seed
      isWinnerAnnounced = auction.hasEnded
      
      let backgroundIndex = auction.noun.seed.background
      nounBackground = composer.backgroundColors[backgroundIndex]
      
      let amount = EtherFormatter.eth(from: auction.amount)
      lastBid = amount ?? R.string.shared.notApplicable()
      
      // On auction end, anounce the winner.
      if auction.hasEnded {
        bidStatus = localize.winningBid()
        winner = auction.bidder?.id ?? "N/A"
      } else {
        // Calculating the time left for the auction to end.
        bidStatus = localize.currentBid()
      }
    }
  }
}
