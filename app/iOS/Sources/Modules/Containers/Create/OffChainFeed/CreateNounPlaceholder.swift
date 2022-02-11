//
//  CreateNounPlaceholder.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-12-26.
//

import SwiftUI
import UIComponents
import Services

extension CreateExperience {
  
  /// A placeholder view for the Create tab for when the user has no created nouns
  struct EmptyNounsView: View {
    
    private let action: () -> Void
    
    private let initialSeed: Seed
    
    init(
      initialSeed: Seed,
      action: @escaping () -> Void
    ) {
      self.initialSeed = initialSeed
      self.action = action
    }

    var body: some View {
      VStack(alignment: .leading, spacing: 0) {
        Text(R.string.create.subhealine())
          .font(.custom(.regular, size: 17))
        
        Spacer()
        
        // TODO: Integrate the NounCreator to randomly generate Traits each time the view appear.
        NounPuzzle(seed: initialSeed)

        OutlineButton(
          text: R.string.create.proceedTitle(),
          largeAccessory: { Image.fingergunsRight },
          action: action)
          .controlSize(.large)
          .padding(.horizontal)

        Spacer()
      }
    }
  }
}
