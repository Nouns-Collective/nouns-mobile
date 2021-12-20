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
  
  private var headImage: String = ""
  
  private var bodyImage: String = ""
  
  private var glassesImage: String = ""
  
  private var accessoryImage: String = ""
  
  init(seed: Seed) {
    self.headImage = nounComposer.heads[seed.head].assetImage
    self.bodyImage = nounComposer.bodies[seed.body].assetImage
    self.glassesImage = nounComposer.glasses[seed.glasses].assetImage
    self.accessoryImage = nounComposer.accessories[seed.accessory].assetImage
  }
  
  init(
    head: String,
    body: String,
    glasses: String,
    accessory: String
  ) {
    self.headImage = head
    self.bodyImage = body
    self.glassesImage = glasses
    self.accessoryImage = accessory
  }
  
  public var body: some View {
    ZStack {
      Image(nounTraitName: headImage)
        .interpolation(.none)
        .resizable()
      
      Image(nounTraitName: bodyImage)
        .interpolation(.none)
        .resizable()
      
      Image(nounTraitName: glassesImage)
        .interpolation(.none)
        .resizable()
      
      Image(nounTraitName: accessoryImage)
        .interpolation(.none)
        .resizable()
    }
    .scaledToFit()
  }
}
