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
    
    /// 
    @Published var seed = Seed.default
  }
}
