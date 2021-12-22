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
    
    private let onChainNounsService: OnChainNounsService
    private var cancellables = Set<AnyCancellable>()
    
    init(onChainNounsService: OnChainNounsService = AppCore.shared.onChainNounsService) {
      self.onChainNounsService = onChainNounsService
    }
    
    func listenLiveAuctionChanges() {
      onChainNounsService.liveAuctionStateDidChange()
        .receive(on: DispatchQueue.main)
        .sink { (auction) in
          self.liveAuction = auction
        }
        .store(in: &cancellables)
      
//      Task {
//        do {
//          isLoading = true
//          liveAuction = try await onChainNounsService.liveAuctionStateDidChange()
//
//        } catch { }
//
//        isLoading = false
//      }
    }
  }
}
