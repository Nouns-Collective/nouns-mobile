//
//  SettledAuctionCard.swift
//  Nouns
//
//  Created by Ziad Tamim on 07.01.22.
//

import SwiftUI
import UIComponents

/// Displays a settled auction along with the date it was created, the owner, and a status label.
struct SettledAuctionCard: View {
  @StateObject var viewModel: ViewModel
  
  var body: some View {
    StandardCard(
      header: viewModel.title,
      accessory: {
        Image.mdArrowCorner
      },
      media: {
        NounPuzzle(seed: viewModel.nounTraits)
          .background(Color(hex: viewModel.nounBackground))
      },
      content: {
        // Displays the domain if it is a nounder noun.
        if viewModel.isNounderOwned {
          ENSText(token: "nounders.eth")
            .font(.custom(.bold, relativeTo: .caption))
            .padding(.top, 4)
        } else if viewModel.showENS {
          ENSText(token: viewModel.nounderToken)
            .font(.custom(.bold, relativeTo: .caption))
            .padding(.top, 4)
        } else {
          // Displays the winning bid on auction.
          SafeLabel(
            viewModel.winnerBid,
            icon: Image.eth)
            .padding(.top, 4)
        }
      })
      .headerStyle(.small)
  }
}
