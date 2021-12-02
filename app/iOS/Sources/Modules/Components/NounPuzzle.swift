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
  
  let seed: Seed
  @Environment(\.nounComposer) private var nounComposer: NounComposer
  
  public var body: some View {
    ZStack {
      Image(nounTraitName: nounComposer.heads[seed.head].assetImage)
        .interpolation(.none)
        .resizable()
      
      Image(nounTraitName: nounComposer.bodies[seed.body].assetImage)
        .interpolation(.none)
        .resizable()
      
      Image(nounTraitName: nounComposer.glasses[seed.glasses].assetImage)
        .interpolation(.none)
        .resizable()
      
      Image(nounTraitName: nounComposer.accessories[seed.accessory].assetImage)
        .interpolation(.none)
        .resizable()
    }
    .scaledToFit()
  }
}
