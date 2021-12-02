//
//  SettledAuctionDetailDialog.swift
//  Nouns
//
//  Created by Ziad Tamim on 02.12.21.
//

import SwiftUI
import Services
import UIComponents

struct SettledAuctionDetailRows: View {
  let auction: Auction
  @Binding var isActivityPresented: Bool
  
  @Environment(\.openURL) private var openURL
  
  private var noun: Noun {
    auction.noun
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
      // Displays the date when the auction was created.
      InfoCell(
        text: R.string.nounProfile.birthday(startTimeDate),
        icon: { Image.birthday })
      
      // Displays the wining bid amount.
      InfoCell(
        text: R.string.nounProfile.bidWinner(),
        calloutText: auction.ethAmount ?? R.string.shared.notApplicable(),
        icon: { Image.wonPrice },
        calloutIcon: { Image.eth })
      
      InfoCell(
        text: R.string.nounProfile.heldBy(),
        calloutText: noun.owner.id,
        icon: { Image.holder },
        accessory: { Image.mdArrowRight },
        action: {
          if let url = URL(string: "https://nouns.wtf/noun/\(noun.id)") {
            openURL(url)
          }
        })
      
      // Action to display the governance details of the auction.
      InfoCell(
        text: R.string.nounProfile.auctionSettledGovernance(),
        icon: { Image.history },
        accessory: { Image.mdArrowRight },
        action: { isActivityPresented.toggle() })
    }
  }
}
