//
//  ExploreExperience.ViewModel.swift
//  Nouns
//
//  Created by Ziad Tamim on 16.12.21.
//

import Foundation
import Services

extension ExploreExperience {
  
  class ViewModel: ObservableObject {
    @Published var liveAuction: Auction?
    @Published var isLoading = false
    
    private let onChainNounsService: OnChainNounsService
    
    init(onChainNounsService: OnChainNounsService = AppCore.shared.onChainNounsService) {
      self.onChainNounsService = onChainNounsService
    }
    
    @MainActor
    func listenLiveAuctionChanges() {
      Task {
        do {
          isLoading = true
          liveAuction = try await onChainNounsService.liveAuctionStateDidChange()
          
        } catch { }
        
        isLoading = false
      }
    }
  }
}
