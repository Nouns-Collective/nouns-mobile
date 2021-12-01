//
//  LiveAuctionCard.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import SwiftUI
import UIComponents
import Services

struct LiveAuctionCard: View {
  @Environment(\.nounComposer) var nounComposer
  
  let auction: Auction
  
  @State private var timeLeft: String = ""
  private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
  
  private var ethPrice: String {
    let formatter = EtherFormatter(from: .wei)
    formatter.unit = .eth
    guard let price = formatter.string(from: auction.amount) else {
      return R.string.shared.notApplicable()
    }
    return price
  }
  
  private func updateTimeLeft() {
    guard let endDateTimeInterval = Double(auction.endTime) else { return }
    
    let currentDate = Date()
    let endDate = Date(timeIntervalSince1970: endDateTimeInterval)
    
    let diffComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: currentDate, to: endDate)
    
    guard let hours = diffComponents.hour,
          let minutes = diffComponents.minute,
          let seconds = diffComponents.second else { return }
    
    timeLeft = R.string.liveAuction.timeLeft(hours, minutes, seconds)
  }
  
  var body: some View {
    StandardCard(
      media: {
        NounPuzzle(
          head: Image(nounTraitName: nounComposer.heads[auction.noun.seed.head].assetImage),
          body: Image(nounTraitName: nounComposer.bodies[auction.noun.seed.body].assetImage),
          glass: Image(nounTraitName: nounComposer.glasses[auction.noun.seed.glasses].assetImage),
          accessory: Image(nounTraitName: nounComposer.accessories[auction.noun.seed.accessory].assetImage))
          .background(Color(hex: nounComposer.backgroundColors[auction.noun.seed.background]))
      },
      header: R.string.explore.noun(auction.noun.id),
      accessoryImage: Image.mdArrowCorner,
      leftDetail: {
        CompoundLabel(
          Text(timeLeft),
          icon: Image.timeleft,
          caption: R.string.liveAuction.timeLeftLabel())
          .onReceive(timer) { _ in
            updateTimeLeft()
          }
      },
      rightDetail: {
        CompoundLabel(
          SafeLabel(ethPrice, icon: Image.eth),
          icon: Image.currentBid,
          caption: R.string.liveAuction.currentBid())
      })
      .onAppear {
        self.updateTimeLeft()
      }
  }
}
