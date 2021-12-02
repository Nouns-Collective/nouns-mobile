//
//  LiveAuctionDetailDialog.swift
//  Nouns
//
//  Created by Ziad Tamim on 02.12.21.
//

import SwiftUI
import Services
import UIComponents

struct LiveAuctionInfoCard: View {
  let auction: Auction
//  @Binding var isActivityPresented: Bool
  
  @EnvironmentObject private var store: AppStore
  @Environment(\.presentationMode) private var presentationMode
  
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
    NavigationView {
      VStack(spacing: 0) {
        Spacer()
        
        NounPuzzle(seed: auction.noun.seed)
        
        HStack {
          Text(R.string.explore.noun(auction.noun.id))
            .font(.custom(.bold, relativeTo: .title2))
          
          Spacer()
          
          SoftButton(icon: { Image.xmark }, action: {
            presentationMode.wrappedValue.dismiss()
          })
        }
        
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
            action: { /*isActivityPresented.toggle()*/ })
        }
        .labelStyle(.titleAndIcon(spacing: 14))
        .padding(.bottom, 40)
        
        // Various available actions.
        HStack {
          // Shares the live auction link.
          SoftButton(
            text: R.string.shared.share(),
            largeAccessory: { Image.share },
            action: { /* showShareSheet.toggle() */ },
            fill: [.width])
          
          // Switch context to the playground exprience using the current Noun's seed.
          SoftButton(
            text: R.string.shared.remix(),
            largeAccessory: { Image.splice },
            action: { },
            fill: [.width])
        }
      }
      .background(Gradient.warmGreydient)
    }
    .onAppear {
      store.dispatch(ListenLiveAuctionRemainingTimeChangesAction(auction: auction))
    }
//    .sheet(isPresented: $showShareSheet) {
//      if let url = URL(string: "https://nouns.wtf/noun/\(noun.id)") {
//        ShareSheet(activityItems: [url])
//      }
//    }
  }
}
