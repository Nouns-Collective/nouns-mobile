//
//  LiveAuctionCard.ViewModel.swift
//  Nouns
//
//  Created by Ziad Tamim on 16.12.21.
//

import Foundation
import Services

extension LiveAuctionCard {
  
  class ViewModel: ObservableObject {
    @Published var auction: Auction
    @Published var isFetching = false
    @Published var remainingTime = R.string.shared.notApplicable()
    
    private let onChainNounsService: OnChainNounsService
    
    init(
      auction: Auction,
      onChainNounsService: OnChainNounsService = AppCore.shared.onChainNounsService
    ) {
      self.auction = auction
      self.onChainNounsService = onChainNounsService
    }
    
    var title: String {
      R.string.explore.noun(auction.noun.id)
    }
    
    var currentBid: String {
      guard let amount = EtherFormatter.eth(
        from: auction.amount
      ) else {
        return R.string.shared.notApplicable()
      }
      
      return amount
    }
    
    @MainActor
    func setUpAuctionTimer() {
      // Update the remaining time.
      Task {
        for await components in auction.componentsSequence.values {
          guard let hour = components.hour,
                let minute = components.minute,
                let second = components.second
          else {
            continue
          }

          remainingTime = R.string.liveAuction.timeLeft(hour, minute, second)
        }
      }
    }
  }
}
