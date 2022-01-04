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

/// Diplay the auction of the day in real time.
struct LiveAuctionCard: View {
  @ObservedObject var viewModel: ViewModel
  
  @State private var showNounProfile = false
  @Environment(\.nounComposer) private var nounComposer: NounComposer
  
  var body: some View {
    StandardCard(
      header: viewModel.title, accessory: {
        Image.mdArrowCorner
          .resizable()
          .scaledToFit()
          .frame(width: 24, height: 24)
      },
      media: {
        NounPuzzle(seed: viewModel.nounSeed)
          .background(Color(hex: viewModel.nounBackground))
      },
      content: {
        HStack {
          // Displays Remaining Time.
          CompoundLabel(
            Text(viewModel.remainingTime),
            icon: Image.timeleft,
            caption: R.string.liveAuction.timeLeftLabel())
          
          Spacer()
          
          // Displays Current Bid.
          CompoundLabel(
            SafeLabel(viewModel.currentBid, icon: Image.eth),
            icon: Image.currentBid,
            caption: R.string.liveAuction.currentBid())
          
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
