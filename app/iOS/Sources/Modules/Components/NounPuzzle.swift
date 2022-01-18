//
//  NounPuzzle.swift
//  
//
//  Created by Ziad Tamim on 04.11.21.
//

import SwiftUI
import Services

/// Builds a Noun given the traits head, glass, body, and accessory.
struct NounPuzzle: View {
  
  @Environment(\.nounComposer) private var nounComposer: NounComposer
  
  private var traits: [String] = []
  
  init(seed: Seed) {
    traits = [
      nounComposer.heads[seed.head].assetImage,
      nounComposer.bodies[seed.body].assetImage,
      nounComposer.glasses[seed.glasses].assetImage,
      nounComposer.accessories[seed.accessory].assetImage,
    ]
  }
  
  init(head: String, body: String, glasses: String, accessory: String) {
    traits = [head, body, glasses, accessory]
  }
  
  public var body: some View {
    ZStack {
      ForEach(traits, id: \.self) {
        Image(nounTraitName: $0)
          .interpolation(.none)
          .resizable()
      }
    }
    .scaledToFit()
  }
}
