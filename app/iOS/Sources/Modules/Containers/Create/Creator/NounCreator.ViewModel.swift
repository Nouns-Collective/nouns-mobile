//
//  NounCreator.ViewModel.swift
//  Nouns
//
//  Created by Ziad Tamim on 20.12.21.
//

import Foundation
import Services
import Combine

extension NounCreator {
  
  final class ViewModel: ObservableObject {
    
    /// List all the different states that the user can be in while creating their noun
    enum Mode {
      
      /// Set when a user wants to cancel their creation process
      case cancel
      
      /// Set when a user is currently creating their noun
      case creating
      
      /// Set when a user is done creating their noun, and is presented a sheet to save their noun
      case done
    }
    
    /// List all various `Noun's Traits Types`.
    enum TraitType: Int, CaseIterable, Hashable {
      case glasses
      case head
      case accessory
      case body
      case background
    }
    
    /// An action struct to update the currently edited trait type
    struct TraitUpdateAction: Equatable {
      
      /// The trait type to update the currently selected trait type to
      var type: TraitType
      
      /// The action that resulted in the trait type update
      var action: Action
      
      /// An enum for the possible types of action that resulted in the trait type update
      enum Action {
        
        /// The user has swiped into/by the trait type section
        case swipe
        
        /// The user has tapped the trait type from the segmented control / picker
        case tap
      }
    }
    
    /// A publisher that publishes trait update actions when receieved to all subscribing views
    public var tapPublisher: AnyPublisher<TraitUpdateAction, Never>

    /// A passthrought subject to send new trait update action values
    private let tapSubject = PassthroughSubject<TraitUpdateAction, Never>()
    
    /// A boolean value for whether or not the `tapSubject` should be paused, with any incoming values and updates being ignored
    private var tapSubjectPaused: Bool = false
    
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
    @Published var currentModifiableTraitType: TraitType = .glasses
    
    /// The name of the noun currently being created
    @Published var nounName: String = ""
    
    /// Inidicates the current state of the user while creating their noun.
    @Published var mode: Mode = .creating
    
    private let offChainNounsService: OffChainNounsService = AppCore.shared.offChainNounsService
    
    init() {
      tapPublisher = tapSubject
        .eraseToAnyPublisher()
    }
    
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
      // Prevents conflicts with `onAppear` on the trait grid if the trait selected exists on the edges of the section
      pauseTapPublisher()
      
      // Sets currently modifiable trait type to the type of the trait
      // that was just selected just in case there was a mismatch between the two
      if currentModifiableTraitType != traitType {
        self.currentModifiableTraitType = traitType
      }
      
      switch traitType {
      case .background:
        seed.background = index
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
    
    /// Returns the selected index given a trait type
    func selectedTrait(forType traitType: TraitType) -> Int {
      switch traitType {
      case .glasses:
        return seed.glasses
      case .head:
        return seed.head
      case .accessory:
        return seed.accessory
      case .body:
        return seed.body
      case .background:
        return seed.background
      }
    }
    
    /// Sets the view state of the creator view
    func setMode(to mode: Mode) {
      self.mode = mode
    }
    
    /// Saves the current created noun
    func save() {
      do {
        try offChainNounsService.store(noun: Noun(name: nounName, owner: Account(), seed: seed))
      } catch {
        print("Error: \(error)")
      }
    }
    
    func didUpdateTraitType(to traitType: TraitType, action: TraitUpdateAction.Action) {
      guard !tapSubjectPaused else { return }
      
      switch action {
      case .tap:
        /// Disable the tap publisher when a new trait type is tapped to prevent conflicting values from being published
        /// as the trait picker grid animates and swipes by intermediate trait types in between the initial trait type
        /// and the newly tapped trait type
        self.pauseTapPublisher()
      default:
        break
      }
      
      currentModifiableTraitType = traitType
      
      let action = TraitUpdateAction(type: traitType, action: action)
      tapSubject.send(action)
    }
    
    private func pauseTapPublisher(for seconds: TimeInterval = 0.35) {
      self.tapSubjectPaused = true
      DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [weak self] in
        self?.tapSubjectPaused = false
      }
    }
  }
}

extension NounCreator.ViewModel.TraitType {
  
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
  static let layeredOrder: [NounCreator.ViewModel.TraitType] = [.background, .body, .accessory, .head, .glasses]
}

extension NounCreator.ViewModel.TraitType: CustomStringConvertible {
 
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
