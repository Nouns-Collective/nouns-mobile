//
//  AuctionInfoContainer.ViewModel.swift
//  Nouns
//
//  Created by Ziad Tamim on 19.12.21.
//

import Foundation
import Services

extension AuctionInfoContainer {
  
  /// The type of pages available.
  enum Page: Int {
    case activity
    case bidHitory
  }
  
  final class ViewModel: ObservableObject {
    let auction: Auction
    
    init(auction: Auction) {
      self.auction = auction
    }
    
    /// The activity page should not be visible when the auction is not settled.
    var isActivityAvailable: Bool {
      auction.settled
    }
    
    /// The initial visible page to display. If the auction is not settled, the auction history takes place.
    var initialVisiblePage: Page {
      isActivityAvailable ? .activity : .bidHitory
    }
  }
}
