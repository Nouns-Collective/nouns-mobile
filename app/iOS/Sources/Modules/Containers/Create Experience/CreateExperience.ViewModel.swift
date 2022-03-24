//
//  CreateExperience.ViewModel.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2022-03-22.
//

import Foundation
import Services

extension CreateExperience {
  
  final class ViewModel: ObservableObject {
    
    /// A binding boolean value to determine if the noun creator should be presented
    @Published var isCreatorPresented = false

    /// The noun profile that is currently presented
    @Published var selectedNoun: Noun?
    
    /// The initial seed to show on the create experience tab as well as when creating a new noun
    @Published var initialSeed: Seed = AppCore.shared.nounComposer.randomSeed()
    
    func randomizeNoun() {
      initialSeed = AppCore.shared.nounComposer.randomSeed()
    }
  }
}
