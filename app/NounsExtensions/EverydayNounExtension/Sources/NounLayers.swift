//
//  NounLayers.swift
//  Everyday Noun Extension
//
//  Created by Ziad Tamim on 12.04.22.
//

import SwiftUI
import Services
import NounsUI

struct NounComposerKey: EnvironmentKey {
  static var defaultValue: NounComposer = OfflineNounComposer.default()
}

extension EnvironmentValues {
  
  var nounComposer: NounComposer {
    get { self[NounComposerKey.self] }
    set { self[NounComposerKey.self] = newValue }
  }
}

/// Builds a Noun given the traits head, glass, body, and accessory.
struct NounLayers: View {
  
  @Environment(\.nounComposer) private var nounComposer: NounComposer
  
  private var traits: [String] = []
  
  init(seed: Seed) {
    traits = [
      nounComposer.bodies[seed.body].assetImage,
      nounComposer.accessories[seed.accessory].assetImage,
      nounComposer.heads[seed.head].assetImage,
      nounComposer.glasses[seed.glasses].assetImage
    ]
  }
  
  var body: some View {
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
