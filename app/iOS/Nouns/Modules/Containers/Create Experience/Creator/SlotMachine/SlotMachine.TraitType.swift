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
