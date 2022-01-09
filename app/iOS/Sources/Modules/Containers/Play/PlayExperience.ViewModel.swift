//
//  PlayExperience.ViewModel.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2022-01-08.
//

import Foundation
import Services

extension PlayExperience {
  
  @MainActor
  final class ViewModel: ObservableObject {
    
    /// Boolean value for whether the user has created any offline nouns
    @Published private(set) var hasCreatedNouns: Bool = false
    
    private let offChainNounsService: OffChainNounsService
    
    init(offChainNounsService: OffChainNounsService = AppCore.shared.offChainNounsService) {
      self.offChainNounsService = offChainNounsService
    }
        
    func checkOfflineNouns() async {
      do {
        for try await nouns in offChainNounsService.nounsStoreDidChange(ascendingOrder: false) {
          hasCreatedNouns = nouns.count > 0
        }
      } catch {
        //
      }
    }
    
    // TODO: - Implement blinking animation logic
  }
}
