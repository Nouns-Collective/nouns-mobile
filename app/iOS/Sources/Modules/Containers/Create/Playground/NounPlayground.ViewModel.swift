//
//  NounPlayground.ViewModel.swift
//  Nouns
//
//  Created by Ziad Tamim on 20.12.21.
//

import Foundation
import Services

extension NounPlayground {
  
  final class ViewModel: ObservableObject {
    
    /// List all variouse `Noun's Traits Types`.
    enum TraitType: Int, CaseIterable, Hashable {
      case glasses
      case head
      case accessory
      case body
      case background
    }
    
    /// The `Seed` in build progress.
    @Published var seed: Seed = {
      Seed(
        background: 0,
        glasses: 0,
        head: 0,
        body: 0,
        accessory: 0
      )
    }()
    
    /// `Noun's Trait` image size.
    let imageSize: Double = 320
    
    /// Indicates the current modifiable trait type selected in the slot machine.
    @Published var currentModifiableTraitType: TraitType = .head
    
    /// Recognizes if the drag gesture should be enabled.
    /// - Parameter type: The Noun's `Trait Type` to validate.
    func isDraggingEnabled(for type: TraitType) -> Bool {
      currentModifiableTraitType == type
    }
    
    /// Moves the currently selected `Noun's Trait` by the given offset.
    func traitOffset(for type: TraitType, by offsetX: Double = 0) -> Double {
      switch type {
      case .background:
        return 0
        
      case .body:
        return (Double(seed.body) * -imageSize) + offsetX
        
      case .accessory:
        return (Double(seed.accessory) * -imageSize) + offsetX
        
      case .head:
        return (Double(seed.head) * -imageSize) + offsetX
        
      case .glasses:
        return (Double(seed.glasses) * -imageSize) + offsetX
      }
    }
    
    /// Selecting a trait by swiping left or right on the noun
    func selectTrait(at offsetX: Double) {
      // Calculate the visible index based on the offsetX progress.
      let progress = -offsetX / imageSize
      let index = Int(progress.rounded())
      
      // Set Bounderies to not scroll over empty.
      let maxLimit = currentModifiableTraitType.traits.endIndex - 1
      let minLimit = 0
      
      switch currentModifiableTraitType {
      case .background:
        break
        
      case .body:
        seed.body = max(
          min(seed.body + index, maxLimit),
          minLimit)
        
      case .accessory:
        seed.accessory = max(
          min(seed.accessory + index, maxLimit),
          minLimit)
        
      case .head:
        seed.head = max(
          min(seed.head + index, maxLimit),
          minLimit)
        
      case .glasses:
        seed.glasses = max(
          min(seed.glasses + index, maxLimit),
          minLimit)
      }
    }
    
    /// Select a trait using the grid view
    func selectTrait(_ index: Int, ofType traitType: TraitType) {
      switch traitType {
      case .background:
        break
        
      case .body:
        seed.body = index
        
      case .accessory:
        seed.accessory = index
        
      case .head:
        seed.head = index
        
      case .glasses:
        seed.glasses = index
      }
    }
    
    func isSelected(_ index: Int, traitType: TraitType) -> Bool {
      switch traitType {
      case .background:
        return false
      case .body:
        return index == seed.body
      case .accessory:
        return index == seed.accessory
      case .head:
        return index == seed.head
      case .glasses:
        return index == seed.glasses
      }
    }
  }
}

extension NounPlayground.ViewModel.TraitType {
  
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
  static let layeredOrder: [NounPlayground.ViewModel.TraitType] = [.background, .body, .accessory, .head, .glasses]
}

extension NounPlayground.ViewModel.TraitType: CustomStringConvertible {
 
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
