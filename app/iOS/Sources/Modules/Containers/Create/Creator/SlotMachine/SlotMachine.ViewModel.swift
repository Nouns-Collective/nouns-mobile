//
//  SlotMachine.ViewModel.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2022-02-11.
//

import SwiftUI
import Combine
import Services

extension Notification.Name {
  
  /// A notification that shoud be dispatched whenever the seed is updated from the slot machine
  /// by swiping left or right to switch between traits. Along with this notification, a `Seed` object
  /// is passed along which is equal to the new value of the seed, after swiping
  static let slotMachineDidUpdateSeed = Notification.Name("slotMachineDidUpdateSeed")
  
  /// A notification that should be dispatched whenever the seed is updated from another source
  /// and should be reflected in the slot machine to match. An example of this is in the `NounCreator`
  /// where the trait grid view can update the seed and the slot machine should match that new
  /// value.  Along with this notification, a `Seed` object is passed along which is equal to the
  /// new value of the seed
  static let slotMachineShouldUpdateSeed = Notification.Name("slotMachineShouldUpdateSeed")
  
  /// A notification that should be dispatched whenever the current modifiable trait type is updated
  /// from another source and should be reflected in the slot machine to match. An example of this
  /// is in the `NounCreator` where the segmented control can update the currently selected trait type
  /// and the slot machine should match that new value to allow swiping between the newly selected trait type.
  /// Along with this notification, a `SlotMachine.ViewModel.TraitType` object is passed along which is
  /// equal to the newly selected trait type
  static let slotMachineShouldUpdateModifiableTraitType = Notification.Name("slotMachineShouldUpdateModifiableTraitType")
}

extension SlotMachine {
  
  final class ViewModel: ObservableObject {
    
    /// List all various `Noun's Traits Types`.
    enum TraitType: Int, CaseIterable, Hashable {
      case glasses
      case head
      case accessory
      case body
      case background
    }
    
    /// The initial seed of the noun creator, reflecting which traits are selected and displayed initially
    private let initialSeed: Seed
    
    /// The current `Seed` in the slot machine
    @Published var seed: Seed = {
      Seed(
        background: 0,
        glasses: 0,
        head: 0,
        body: 0,
        accessory: 0
      )
    }()
    
    /// Indicates the current modifiable trait type selected in the slot machine.
    @Published var currentModifiableTraitType: TraitType = .glasses
    
    private var cancellables = Set<AnyCancellable>()
    
    init(initialSeed: Seed = Seed.default) {
      self.initialSeed = initialSeed
      self.seed = initialSeed
      
      setupNotifications()
    }
    
    private func setupNotifications() {
      NotificationCenter.default
        .publisher(for: Notification.Name.slotMachineShouldUpdateSeed)
        .compactMap { $0.object as? Seed }
        .removeDuplicates()
        .sink { newSeed in
          self.seed = newSeed
        }
        .store(in: &cancellables)
      
      NotificationCenter.default
        .publisher(for: Notification.Name.slotMachineShouldUpdateModifiableTraitType)
        .compactMap { $0.object as? TraitType }
        .removeDuplicates()
        .sink { newTraitType in
          self.currentModifiableTraitType = newTraitType
        }
        .store(in: &cancellables)
    }
    
    /// `Noun's Trait` image size.
    let imageSize: Double = 320
    
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
    
    /// Returns a boolean indicating if an index is the selected index given a trait type
    func isSelected(_ index: Int, traitType: TraitType) -> Bool {
      switch traitType {
      case .background:
        return index == seed.background
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
    
    /// Recognizes if the drag gesture should be enabled.
    /// - Parameter type: The Noun's `Trait Type` to validate.
    func isDraggingEnabled(for type: TraitType) -> Bool {
      currentModifiableTraitType == type
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
      
      NotificationCenter.default.post(name: Notification.Name.slotMachineDidUpdateSeed, object: seed)
    }
  }
}

extension SlotMachine.ViewModel.TraitType {
  
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
  static let layeredOrder: [SlotMachine.ViewModel.TraitType] = [.background, .body, .accessory, .head, .glasses]
}

extension SlotMachine.ViewModel.TraitType {
  
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
