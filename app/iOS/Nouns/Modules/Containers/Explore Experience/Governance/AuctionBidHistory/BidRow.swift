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
import Services

struct BidRow: View {
  let viewModel: ViewModel
  
  var body: some View {
    PlainCell {
      VStack(alignment: .leading, spacing: 8) {
        HStack(alignment: .center) {
          // Bid amount
          Label {
            Text(viewModel.bidAmount)
              .foregroundColor(Color.componentNounsBlack)
              .font(.custom(.bold, relativeTo: .title3))
          } icon: {
            Image.eth
              .asThumbnail(maxWidth: 18, maxHeight: 18)
          }
          .labelStyle(.titleAndIcon(spacing: 4))
          
          Spacer()
          
          // Timestamp of the bid
          Text(viewModel.bidDate)
            .font(Font.custom(.medium, relativeTo: .caption))
            .opacity(0.5)
        }
        
        // An Account is any address that holds any amount of Nouns
        Label {
          ENSText(token: viewModel.bidderIdentifier)
            .font(.custom(.medium, relativeTo: .subheadline))
            .foregroundColor(Color.componentNounsBlack)
          
        } icon: {
          // Token avatar
          Image(R.image.placeholderEns.name)
            .asThumbnail()
            .clipShape(Circle())
        }
        
      }.padding()
    }
  }
}
