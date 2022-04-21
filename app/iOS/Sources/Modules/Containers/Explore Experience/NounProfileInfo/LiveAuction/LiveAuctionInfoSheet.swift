//
//  LiveAuctionInfoSheet.swift
//  Nouns
//
//  Created by Ziad Tamim on 02.12.21.
//

import SwiftUI
import Services
import UIComponents

struct LiveAuctionInfoSheet: View {
  @ObservedObject var viewModel: ViewModel
  @Binding var isActivityPresented: Bool
  
  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      // Displays the remaining time for the auction to be settled.
      InfoCell(
        text: R.string.nounProfile.auctionUnsettledTimeLeftLabel(),
        icon: { Image.timeleft },
        supplementaryView: {
          if viewModel.auction.hasEnded {
            Text("00h:00m:00s")
              .font(.custom(.medium, relativeTo: .footnote))
              .padding(.leading, 4)
          } else {
            CountdownLabel(endTime: viewModel.auction.endTime)
              .font(.custom(.medium, relativeTo: .footnote))
              .padding(.leading, 4)
          }
        })
      
      // Displays the date when the auction was created.
      InfoCell(
        text: viewModel.birthdate,
        icon: { Image.birthday })
      
      // Displays the current bid amount.
      InfoCell(
        text: R.string.nounProfile.auctionUnsettledLastBid(),
        icon: { Image.currentBid },
        supplementaryView: {
          Label {
            Text(viewModel.lastBid)
          } icon: {
            Image.eth
          }
          .labelStyle(.calloutLabel(spacing: 2))
          .padding(.leading, 4)
        })
      
      // Action to display the governance details of the auction.
      InfoCell(
        text: R.string.nounProfile.auctionUnsettledGovernance(),
        icon: { Image.history },
        accessory: { Image.mdArrowRight },
        action: { isActivityPresented.toggle() })
    }
    .labelStyle(.titleAndIcon(spacing: 14))
    .padding(.bottom, 40)
  }
}
