// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Mohammed Ibrahim
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
