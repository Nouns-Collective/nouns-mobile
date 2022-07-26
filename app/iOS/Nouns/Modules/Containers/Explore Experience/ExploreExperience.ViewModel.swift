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
import Combine
import Services

extension ExploreExperience {
  
  class ViewModel: ObservableObject {
    private let service: OnChainNounsService
    
    init(service: OnChainNounsService = AppCore.shared.onChainNounsService) {
      self.service = service
    }
    
    // MARK: - Live Auction
    @Published var liveAuction: Auction?
    @Published var failedToLoadLiveAuction: Bool = false
    private var isStreamingLiveAuction: Bool = false
    
    /// Boolean value to determine if both live auction and settled auctions are failing to load
    var failedToLoadExplore: Bool {
      failedToLoadLiveAuction && (failedToLoadSettledAuctions && auctions.isEmpty)
    }
    
    /// Listens to changes for the live auction's bid information and completion status
    @MainActor
    func listenLiveAuctionChanges() async {
      guard isStreamingLiveAuction == false else {
        return
      }
      failedToLoadLiveAuction = false
      isStreamingLiveAuction = true
      
      do {
        for try await auction in service.liveAuctionStateDidChange() {
          liveAuction = auction
        }
      } catch {
        failedToLoadLiveAuction = true
        isStreamingLiveAuction = false

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
          Task {
            await self.listenLiveAuctionChanges()
          }
        })
      }
    }
    
    // MARK: - Settled Auctions
    @Published var auctions = [Auction]()
    @Published var failedToLoadSettledAuctions: Bool = false
    @Published var shouldLoadMore: Bool = false
    @Published var isLoadingSettledAuctions: Bool = false
    private var isStreamingSettledAuctions: Bool = false
    
    private let pageLimit = 20
    
    /// A boolean to determine if the settled auctions are initially loading, defined
    /// by the loading state being `true` and for the settled auctions array `auctions` being empty
    var isInitiallyLoadingSettledAuctions: Bool {
      isLoadingSettledAuctions && auctions.isEmpty
    }
    
    /// A count of the number of settled auctions that have been loaded into the feed that aren't nounder-owned nouns.
    private var notNounderOwnedCount: Int {
      auctions.filter { $0.noun.isNounderOwned == false }.count
    }
    
    /// Listens for recently-settled auctions and adds them to the feed
    @MainActor
    func listenSettledAuctionsChanges() async {
      guard isStreamingSettledAuctions == false else {
        return
      }
      isStreamingSettledAuctions = true

      do {
        for try await settledAuctions in service.settledAuctionsDidChange() {
          settledAuctions.forEach { settledAuction in
            if !auctions.contains(where: { auction in
              auction.id == settledAuction.id
            }) {
              auctions.insert(settledAuction, at: 0)
            }
          }
        }
      } catch {
        isStreamingSettledAuctions = false
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
          Task {
            await self.listenSettledAuctionsChanges()
          }
        })
      }
    }
    
    /// Loads settled auctions
    @MainActor
    func loadAuctions() {
      Task {
        failedToLoadSettledAuctions = false
        
        do {
          isLoadingSettledAuctions = true
          // Load next batch of the settled auctions from the network.
          // The cursor should be set to the amount of non-nounder owned
          // nouns in the view model as nounder owned nouns are not considered "auctions"
          let auctions = try await service.fetchAuctions(
            settled: true,
            includeNounderOwned: true,
            limit: pageLimit,
            cursor: notNounderOwnedCount,
            sortDescending: true
          )
          
          shouldLoadMore = auctions.hasNext
                          
          self.auctions += uniqueAuctions(auctions.data)
          
        } catch {
          failedToLoadSettledAuctions = true
        }
        
        isLoadingSettledAuctions = false
      }
    }
    
    /// Helper function to prevent duplicate auctions from being shown in the feed
    ///
    /// This can be caused randomly be race conditions, espeically on initial launch of the app
    /// where `onAppear` can be called more than once invoking the `loadAuctions` method twice.
    private func uniqueAuctions(_ fetchedAuctions: [Auction]) -> [Auction] {
      let keys = self.auctions.map { $0.id }
      
      return fetchedAuctions.filter { auction in
        return !keys.contains(auction.id)
      }
    }

    func onAppear() {
      AppCore.shared.analytics.logScreenView(withScreen: AnalyticsEvent.Screen.explore)
    }
  }
}
