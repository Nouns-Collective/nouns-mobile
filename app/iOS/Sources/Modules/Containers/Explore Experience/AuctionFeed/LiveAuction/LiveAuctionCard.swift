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
import SpriteKit

/// Display the auction of the day in real time.
struct LiveAuctionCard: View {
  
  @ObservedObject var viewModel: ViewModel
  
  @State private var showNounProfile = false
  
  @State private var width: CGFloat = 100
  
  /// A view that displays an animated noun.
  ///
  /// - Returns: This view contains the play scene to animate the Noun's eyes.
  private let talkingNoun: TalkingNoun
  
  init(viewModel: ViewModel) {
    self.viewModel = viewModel
    talkingNoun = TalkingNoun(seed: viewModel.auction.noun.seed)
  }
  
  var body: some View {
    StandardCard(
      header: viewModel.title, accessory: {
        Image.mdArrowCorner
          .resizable()
          .scaledToFit()
          .frame(width: 24, height: 24)
      },
      media: {
        SpriteView(scene: talkingNoun, options: [.allowsTransparency])
          .background(
            GeometryReader { proxy in
              Color(hex: viewModel.nounBackground)
                .onAppear {
                  self.width = proxy.size.width
                }
            }
          )
          .frame(
            minWidth: 100,
            idealWidth: self.width,
            maxWidth: .infinity,
            minHeight: 100,
            idealHeight: self.width,
            maxHeight: .infinity,
            alignment: .center
          )
      },
      content: {
        HStack {
          if viewModel.isWinnerAnnounced {
            // Displays the winner.
            CompoundLabel({
              ENSText(token: viewModel.winner)
                .font(.custom(.medium, relativeTo: .footnote))
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
      .headerStyle(.large)
      .onTapGesture {
        showNounProfile.toggle()
      }
      .fullScreenCover(isPresented: $showNounProfile) {
        NounProfileInfo(viewModel: .init(auction: viewModel.auction))
      }
  }
}
