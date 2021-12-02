//
//  LiveAuctionCard.swift
//  Nouns
//
//  Created by Ziad Tamim on 01.12.21.
//

import SwiftUI
import Services
import UIComponents

/// Diplay the auction of the day in real time.
struct LiveAuctionCard: View {
  let auction: Auction
  
  @EnvironmentObject private var store: AppStore
  @Environment(\.nounComposer) private var nounComposer
  
  private var liveAuctionState: LiveAuctionState {
    store.state.auction.liveAuction
  }
  
  private var remainingTime: String {
    guard let hour = liveAuctionState.remainingTime?.hour,
          let minute = liveAuctionState.remainingTime?.minute,
          let second = liveAuctionState.remainingTime?.second
    else {
      return R.string.shared.notApplicable()
    }
    
    return R.string.liveAuction.timeLeft(hour, minute, second)
  }
  
  var body: some View {
    StandardCard(
      media: {
        NounPuzzle(seed: auction.noun.seed)
          .background(Color(hex: nounComposer.backgroundColors[auction.noun.seed.background]))
      },
      header: R.string.explore.noun(auction.noun.id),
      accessoryImage: Image.mdArrowCorner,
      leftDetail: {
        // Displays Remaining Time.
        CompoundLabel(
          Text(remainingTime),
          icon: Image.timeleft,
          caption: R.string.liveAuction.timeLeftLabel())
      },
      rightDetail: {
        // Displays Current Bid.
        CompoundLabel(
          SafeLabel(
            auction.ethAmount ?? R.string.shared.notApplicable(),
            icon: Image.eth
          ),
          icon: Image.currentBid,
          caption: R.string.liveAuction.currentBid())
      })
      .onAppear {
        store.dispatch(ListenLiveAuctionRemainingTimeChangesAction(auction: auction))
      }
  }
}
