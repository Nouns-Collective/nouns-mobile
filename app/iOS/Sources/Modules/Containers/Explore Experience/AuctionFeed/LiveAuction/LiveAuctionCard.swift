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
  
  static let liveAuctionMarqueeString = Array(repeating: R.string.shared.liveAuction().uppercased(), count: 10).joined(separator: "       ")
  
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
        VStack(spacing: 0) {
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
            
          MarqueeText(text: LiveAuctionCard.liveAuctionMarqueeString, alignment: .center)
            .padding(.top, 5)
            .padding(.bottom, 4)
            .border(width: 2, edges: [.top], color: .componentNounsBlack)
            .background(Color.white)
        }
      },
      content: {
        HStack {
          Group {
            if viewModel.isWinnerAnnounced {
              // Displays the winner.
              CompoundLabel({
                ENSText(token: viewModel.winner)
                  .font(.custom(.medium, relativeTo: .footnote))
              }, icon: Image.crown, caption: R.string.liveAuction.winner())
              
            } else {
              // Displays remaining time.
              CompoundLabel({
                CountdownLabel(endTime: viewModel.auction.endTime)
              },
              icon: Image.timeleft,
              caption: R.string.liveAuction.timeLeftLabel())
            }
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          
          // Displays Bid Status.
          CompoundLabel({
            SafeLabel(viewModel.lastBid, icon: Image.eth) },
                        icon: Image.currentBid,
                        caption: viewModel.bidStatus)
          .frame(maxWidth: .infinity, alignment: .leading)
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
      .onWidgetOpen {
        AppCore.shared.analytics.logEvent(withEvent: .openAppFromWidget, parameters: ["noun_id": viewModel.auction.noun.id])
        showNounProfile = true
      }
  }
}
