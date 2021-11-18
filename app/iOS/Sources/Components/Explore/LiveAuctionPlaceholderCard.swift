//
//  LiveAuctionPlaceholderCard.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-11-18.
//

import SwiftUI
import UIComponents

struct LiveAuctionPlaceholderCard: View {
    var body: some View {
      StandardCard(
        media: {
          Image(R.image.placeholder.name)
            .resizable()
            .scaledToFit()
        },
        header: "Noun 100",
        accessoryImage: Image.mdArrowCorner,
        leftDetail: {
          CompoundLabel(Text("9h 17m 23s"), icon: Image.timeleft, caption: "Remaining")
        },
        rightDetail: {
          CompoundLabel(SafeLabel("100.00", icon: Image.eth), icon: Image.currentBid, caption: "Current bid")
        })
    }
}
