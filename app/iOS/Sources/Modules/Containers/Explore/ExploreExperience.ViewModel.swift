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
    
    private let service: OnChainNounsService
    private var cancellables = Set<AnyCancellable>()
    
    init(service: OnChainNounsService = AppCore.shared.onChainNounsService) {
      self.service = service
    }
    
    @MainActor
    func listenLiveAuctionChanges() async {
      for await auction in service.liveAuctionStateDidChange() {
        self.liveAuction = auction
      }
    }
  }
}
