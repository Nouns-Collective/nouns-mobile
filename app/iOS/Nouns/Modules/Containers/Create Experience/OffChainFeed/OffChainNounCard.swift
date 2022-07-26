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
import Services
import NounsUI

/// A card to display an offline noun card, created by the user through the noun creator
struct OffChainNounCard: View {
  @StateObject var viewModel: ViewModel
  let animation: Namespace.ID
  
  var body: some View {
    StandardCard(
      header: viewModel.noun.name,
      accessory: {
        Image.mdArrowCorner
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 24, height: 24, alignment: .center)
      },
      media: {
        NounPuzzle(seed: viewModel.noun.seed)
          .matchedGeometryEffect(id: "\(viewModel.noun.id)-puzzle", in: animation)
          .background(Gradient(NounCreator.backgroundColors[viewModel.noun.seed.background]))
      },
      content: {
        Text(viewModel.nounBirthday)
          .font(.custom(.regular, relativeTo: .footnote))
          .padding(.top, 20)
      })
      .headerStyle(.large)
  }
}
