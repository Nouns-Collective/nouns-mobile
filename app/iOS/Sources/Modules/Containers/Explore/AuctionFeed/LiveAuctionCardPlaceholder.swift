//
//  LiveAuctionCardPlaceholder.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2022-01-17.
//

import SwiftUI
import UIComponents

struct LiveAuctionCardPlaceholder: View {
  
  var body: some View {
    StandardCard(
      header: "---------", accessory: {
        Image.mdArrowCorner
          .resizable()
          .scaledToFit()
          .frame(width: 24, height: 24)
      },
      media: {
        Color.gray
          .aspectRatio(1.0, contentMode: .fit)
      },
      content: {
        HStack {
          // Displays remaining time.
          CompoundLabel({
            Text("-------") },
                        icon: Image.timeleft,
                        caption: "------------")
          
          Spacer()
          
          // Displays Bid Status.
          CompoundLabel({
            SafeLabel("-------", icon: Image.eth) },
                        icon: Image.currentBid,
                        caption: "------------")
          
          Spacer()
        }
        .padding(.top, 20)
      })
      .loading()
  }
}

struct LiveAuctionCardPlaceholder_Previews: PreviewProvider {
  static var previews: some View {
    LiveAuctionCardPlaceholder()
  }
}
