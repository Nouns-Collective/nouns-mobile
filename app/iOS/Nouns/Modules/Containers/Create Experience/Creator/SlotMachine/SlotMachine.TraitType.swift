//
//  SlotMachine.TraitType.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2022-02-11.
//

import SwiftUI
import Combine
import Services

extension SlotMachine.TraitType {
  
  private var composer: NounComposer {
    AppCore.shared.nounComposer
  }
  
  /// Traits displayed in the same order as the trait picker
  var traits: [Trait] {
    switch self {
    case .background:
      return []
      
    case .body:
      return composer.bodies
      
    case .accessory:
      return composer.accessories
      
    case .head:
      return composer.heads
      
    case .glasses:
      return composer.glasses
    }
  }
  
  /// This is the order that the assets and traits should be presented in order to replicate how the nouns should look
  static let layeredOrder: [SlotMachine.TraitType] = [.background, .body, .accessory, .head, .glasses]
  
  var description: String {
    switch self {
    case .background:
      return R.string.shared.background()
      
    case .body:
      return R.string.shared.body()
      
    case .accessory:
      return R.string.shared.accessory()
      
    case .head:
      return R.string.shared.head()
      
    case .glasses:
      return R.string.shared.glasses()
    }
  }
}
