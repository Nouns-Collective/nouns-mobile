// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Ziad Tamim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import SwiftUI
import NounsUI

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
