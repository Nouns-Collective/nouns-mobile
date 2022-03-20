//
//  NounCreator.ViewModel.swift
//  Nouns
//
//  Created by Ziad Tamim on 20.12.21.
//

import Foundation
import Services
import SwiftUI
import Combine

typealias TraitType = SlotMachine.ViewModel.TraitType

extension Notification.Name {
  
  struct SlotMachine {
    
    static let slotMachineDidUpdateSeed = Notification.Name("slotMachineDidUpdateSeed")
  }
}

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
    
    /// A publisher that publishes trait update actions when receieved to all subscribing views
    public var tapPublisher: AnyPublisher<TraitType, Never>
    
    /// A passthrought subject to send new trait update action values
    private let tapSubject = PassthroughSubject<TraitType, Never>()
    
    /// A boolean value for whether or not subsequent trait type selection updates
    /// should be paused, with any incoming values and updates being ignored
    private var traitUpdatesPaused: Bool = false
    
    private var visibleSections: [TraitType] = []
    
    /// The `Seed` in build progress.
    @Published var seed: Seed = .default
    
    /// Indicates the current modifiable trait type selected in the slot machine.
    @Published var currentModifiableTraitType: TraitType = .glasses {
      didSet {
        NotificationCenter.default.post(name: Notification.Name.slotMachineShouldUpdateModifiableTraitType, object: currentModifiableTraitType)
      }
    }
    
    /// The name of the noun currently being created
    @Published var nounName: String = ""
    
    /// Inidicates the current state of the user while creating their noun.
    @Published var mode: Mode = .creating
    
    /// Indiicates whether or not to show the confetti overlay, triggered after finishing the creation of a noun
    @Published private(set) var showConfetti: Bool = false
    
    /// A seperate boolean for showing/hiding the confetti in order to hide the confetti first before scaling it down
    @Published private(set) var finishedConfetti: Bool = false
    
    /// The initial seed of the noun creator, reflecting which traits are selected and displayed initially
    @Published public var initialSeed: Seed
    
    /// An action to be carried out when `isEditing` is set to `true` and the user has completed editing their noun
    public var didEditNoun: (_ seed: Seed) -> Void = { _ in }
    
    /// Boolean value to determine if the current noun is being editing (pre-existing) or if it's a new noun being created
    public let isEditing: Bool
    
    private let offChainNounsService: OffChainNounsService = AppCore.shared.offChainNounsService
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
      initialSeed: Seed = Seed.default,
      isEditing: Bool = false,
      didEditNoun: @escaping (_ seed: Seed) -> Void = { _ in }
    ) {
      self.initialSeed = initialSeed
      self.isEditing = isEditing
      self.didEditNoun = didEditNoun
      self.seed = initialSeed
      
      tapPublisher = tapSubject
        .eraseToAnyPublisher()
      
      setupNotifications()
    }
    
    /// Sets up notification to listen to slot machine value changes and update
    /// the `seed` in this view model accordingly
    private func setupNotifications() {
      NotificationCenter.default
        .publisher(for: Notification.Name.slotMachineDidUpdateSeed)
        .compactMap { $0.object as? Seed }
        .removeDuplicates()
        .sink { newSeed in
          self.seed = newSeed
        }
        .store(in: &cancellables)
    }
    
    /// Select a trait using the grid view
    func selectTrait(_ index: Int, ofType traitType: TraitType) {
      // Prevents conflicts with `onAppear` on the trait grid if the trait selected exists on the edges of the section
      pauseTraitUpdates()
      
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
      
      NotificationCenter.default.post(name: Notification.Name.slotMachineShouldUpdateSeed, object: seed)
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
    
    /// Action when the user has pressed the `Done` button on the top right
    func didFinish() {
      // If the user is editing an existing noun, only the designated
      // action should be executed and the created should then be dismissed.
      // Otherwise, confetti appears and a dialog prompting more details is presented
      // before actually saving the new noun
      if isEditing {
        didEditNoun(seed)
      } else {
        toggleConfetti()
        setMode(to: .done)
      }
    }
    
    /// Saves the current created noun
    func save() {
      do {
        try offChainNounsService.store(noun: Noun(name: nounName, owner: Account(), seed: seed))
      } catch {
        print("Error: \(error)")
      }
    }
    
    /// Toggles the confetti view
    func toggleConfetti() {
      showConfetti = true
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        self.hideConfetti()
      }
    }
    
    private func hideConfetti() {
      withAnimation(.easeIn(duration: 1.5)) {
        self.finishedConfetti = true
      }
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
        self.finishedConfetti = false
        self.showConfetti = false
      }
    }
    
    /// Triggered when a trait type has been selected from the outline picker
    func didTapTraitType(to traitType: TraitType) {
      guard !traitUpdatesPaused else { return }
      
      // Pauses trait updates for some time as there can be conflicts
      // when the scroll animation passes by intermediate trait sections, which
      // would call traitSectionDidAppear or traitSectionDidDisappear
      self.pauseTraitUpdates()
      
      currentModifiableTraitType = traitType
      
      tapSubject.send(traitType)
    }
    
    /// A method to keep track of when a trait section has disappeared completely from the grid
    func traitSectionDidDisappear(_ traitType: TraitType) {
      visibleSections.removeAll { $0 == traitType }
      
      guard !traitUpdatesPaused else { return }
      
      // When a section disappears, the selected type should be the most recently
      // appeared section, until traitSectionDidAppear gets called which would then
      // update the currently selected type again
      currentModifiableTraitType = visibleSections.last ?? .glasses
    }
    
    /// A method to keep track of when a trait section has first appeared in the grid
    func traitSectionDidAppear(_ traitType: TraitType) {
      visibleSections.append(traitType)
      
      guard !traitUpdatesPaused else { return }
      
      // When a new section appears, the selected type should be that section
      currentModifiableTraitType = visibleSections.last ?? .glasses
    }
    
    /// Temporarily pauses
    private func pauseTraitUpdates(for seconds: TimeInterval = 0.35) {
      self.traitUpdatesPaused = true
      DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [weak self] in
        self?.traitUpdatesPaused = false
      }
    }
    
    /// Randomizes the noun
    func randomizeNoun() {
      self.initialSeed = AppCore.shared.nounComposer.randomSeed()
      self.seed = AppCore.shared.nounComposer.randomSeed()
      
      NotificationCenter.default.post(name: Notification.Name.slotMachineShouldUpdateSeed, object: seed)
    }
  }
}
