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

extension AuctionInfo {
  
  /// The type of pages available.
  enum Page: Int, Hashable {
    case activity
    case bidHitory
  }
  
  class ViewModel: ObservableObject {
    let auction: Auction
    
    init(auction: Auction) {
      self.auction = auction
    }
    
    /// The activity page should not be visible when the auction is not settled.
    var isActivityAvailable: Bool {
      auction.settled
    }
    
    var isBidHistoryAvailable: Bool {
      !auction.noun.isNounderOwned
    }
    
    /// The initial visible page to display. If the auction is not settled, the auction history takes place.
    var initialVisiblePage: Page {
      isActivityAvailable ? .activity : .bidHitory
    }

    func onAppear() {
      AppCore.shared.analytics.logScreenView(withScreen: AnalyticsEvent.Screen.auctionInfo)
    }
  }
}
