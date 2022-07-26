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

/// A placeholder noun card view when nouns are loading
struct CardPlaceholder: View {
  let count: Int
  
  private let gridLayout = [
    GridItem(.flexible(), spacing: 20),
    GridItem(.flexible(), spacing: 20),
  ]
  
  var body: some View {
    LazyVGrid(columns: gridLayout, spacing: 20) {
      ForEach(1...count, id: \.self) { _ in
        StandardCard(
          header: "---------",
          accessory: {
            Image.mdArrowCorner
          },
          media: {
            Image(R.image.placeholder.name)
              .resizable()
              .scaledToFit()
          },
          content: {
            SafeLabel("------", icon: Image.eth)
              .padding(.top, 8)
          })
          .headerStyle(.small)
          .loading()
      }
    }
  }
}
