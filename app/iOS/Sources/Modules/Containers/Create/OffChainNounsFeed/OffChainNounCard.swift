//
//  OfflineNounCard.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-11-26.
//

import SwiftUI
import Services
import UIComponents

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
          .background(Gradient.cherrySunset)
      },
      content: {
        Text(viewModel.nounBirthday)
          .font(.custom(.regular, size: 15))
          .padding(.top, 20)
      })
      .headerStyle(.large)
  }
}
