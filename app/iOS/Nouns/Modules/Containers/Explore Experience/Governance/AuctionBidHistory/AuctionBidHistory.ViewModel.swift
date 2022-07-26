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

extension AuctionBidHistory {
  
  class ViewModel: ObservableObject {
    let auction: Auction
    
    @Published var bids = [Bid]()
    @Published var isLoading = false
    @Published var shouldLoadMore = true
    @Published var failedToLoadMore = false
    
    private let pageLimit = 20
    private let service: OnChainNounsService
    
    /// Only show the empty placeholder when there are no bids and when the data source is not loading
    /// This occurs mainly on initial appearance, before any bids have loaded
    var isEmpty: Bool {
      bids.isEmpty && !isLoading
    }
    
    init(
      auction: Auction,
      service: OnChainNounsService = AppCore.shared.onChainNounsService
    ) {
      self.auction = auction
      self.service = service
    }
    
    var title: String {
      R.string.explore.noun(auction.noun.id)
    }
    
    @MainActor
    func fetchBidHistory() async {
      failedToLoadMore = false
      
      do {
        isLoading = true
        
        let bids = try await service.fetchBids(
          for: auction.noun.id,
          limit: pageLimit,
          after: bids.count
        )
        
        shouldLoadMore = bids.hasNext
        
        self.bids += bids.data
        
      } catch {
        failedToLoadMore = true
      }
      
      isLoading = false
    }
  }
}
