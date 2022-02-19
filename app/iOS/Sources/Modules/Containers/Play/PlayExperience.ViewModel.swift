//
//  PlayExperience.ViewModel.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2022-01-08.
//

import Foundation
import Services

extension PlayExperience {
  
  class ViewModel: ObservableObject {
    
    /// An initial random `seed` to be presented.
    @Published var seed = Seed.default
  }
}
