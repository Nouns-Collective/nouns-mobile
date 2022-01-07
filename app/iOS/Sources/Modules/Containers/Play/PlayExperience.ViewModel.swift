//
//  PlayExperience.ViewModel.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2022-01-08.
//

import Foundation

extension PlayExperience {
  
  @MainActor
  final class ViewModel: ObservableObject {
    
    @Published private(set) var hasCreatedNouns: Bool = false
    
    // TODO: - Implement blinking animation logic
    
    func checkOfflineNouns() {
      
    }
  }
}
