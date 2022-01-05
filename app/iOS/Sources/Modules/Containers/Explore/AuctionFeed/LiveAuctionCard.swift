//
//  LiveAuctionCard.swift
//  Nouns
//
//  Created by Ziad Tamim on 01.12.21.
//

import SwiftUI
import Services
import Combine
import UIComponents

/// Display the auction of the day in real time.
struct LiveAuctionCard: View {
  @ObservedObject var viewModel: ViewModel
  
  @State private var showNounProfile = false
  
  var body: some View {
    StandardCard(
      header: viewModel.title, accessory: {
        Image.mdArrowCorner
          .resizable()
          .scaledToFit()
          .frame(width: 24, height: 24)
      },
      media: {
        NounPuzzle(seed: viewModel.nounTrait)
          .background(Color(hex: viewModel.nounBackground))
      },
      content: {
        HStack {
          if viewModel.isWinnerAnounced {
            // Displays the winner.
            CompoundLabel({
              ENSText(token: viewModel.winner)
                .font(.custom(.medium, relativeTo: .subheadline))
            }, icon: Image.crown, caption: R.string.liveAuction.winner())
            
          } else {
            // Displays remaining time.
            CompoundLabel({
              Text(viewModel.remainingTime) },
                          icon: Image.timeleft,
                          caption: R.string.liveAuction.timeLeftLabel())
          }
          
          Spacer()
          
          // Displays Bid Status.
          CompoundLabel({
            SafeLabel(viewModel.lastBid, icon: Image.eth) },
                        icon: Image.currentBid,
                        caption: viewModel.bidStatus)
          
          Spacer()
        }
        .padding(.top, 20)
      })
      .onTapGesture {
        showNounProfile.toggle()
      }
      .fullScreenCover(isPresented: $showNounProfile) {
        NounProfileInfoCard(viewModel: .init(auction: viewModel.auction))
      }
  }
}
