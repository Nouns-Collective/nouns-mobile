//
//  ExploreExperience.ViewModel.swift
//  Nouns
//
//  Created by Ziad Tamim on 16.12.21.
//

import Foundation
import Combine
import Services

extension ExploreExperience {
  
  class ViewModel: ObservableObject {
    @Published var liveAuction: Auction?
    @Published var isLoading = false
    @Published var failedToLoadAuction: Bool = false
    
    private let service: OnChainNounsService
    
    init(service: OnChainNounsService = AppCore.shared.onChainNounsService) {
      self.service = service
    }
    
    @MainActor
    func listenLiveAuctionChanges() async {
      failedToLoadAuction = false
      
      do {
        for try await auction in service.liveAuctionStateDidChange() {
          self.liveAuction = auction
        }
      } catch {
        failedToLoadAuction = true
      }
    }
  }
}
