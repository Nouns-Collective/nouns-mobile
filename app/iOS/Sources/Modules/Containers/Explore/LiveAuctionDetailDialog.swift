//
//  LiveAuctionDetailDialog.swift
//  Nouns
//
//  Created by Ziad Tamim on 02.12.21.
//

import SwiftUI
import Services
import UIComponents

struct LiveAuctionDetailDialog: View {
  let auction: Auction
  @Binding var isActivityPresented: Bool
  
  @EnvironmentObject private var store: AppStore
  
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
  
  private var startTimeDate: String {
    guard let timeInterval = Double(auction.startTime) else {
      return R.string.shared.notApplicable()
    }
    
    let date = Date(timeIntervalSince1970: timeInterval)
    return DateFormatter.string(from: date)
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      // Displays the remaining time for the auction to be settled.
      InfoCell(
        text: R.string.nounProfile.auctionUnsettledTimeLeftLabel(),
        calloutText: remainingTime,
        icon: { Image.timeleft })
      
      // Displays the date when the auction was created.
      InfoCell(
        text: R.string.nounProfile.birthday(startTimeDate),
        icon: { Image.birthday })
      
      // Displays the current bid amount.
      InfoCell(
        text: R.string.nounProfile.auctionUnsettledLastBid(),
        calloutText: auction.ethAmount ?? R.string.shared.notApplicable(),
        icon: { Image.currentBid },
        calloutIcon: { Image.eth })
      
      // Action to display the governance details of the auction.
      InfoCell(
        text: R.string.nounProfile.auctionUnsettledGovernance(),
        icon: { Image.history },
        accessory: { Image.mdArrowRight },
        action: { isActivityPresented.toggle() })
    }
    .onAppear {
      store.dispatch(ListenLiveAuctionRemainingTimeChangesAction(auction: auction))
    }
  }
}
