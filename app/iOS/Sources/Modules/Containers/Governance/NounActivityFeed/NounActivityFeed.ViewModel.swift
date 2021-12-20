//
//  NounActivityFeed.ViewModel.swift
//  Nouns
//
//  Created by Ziad Tamim on 17.12.21.
//

import Foundation
import Services

extension NounActivityFeed {
  
  final class ViewModel: ObservableObject {
    let auction: Auction
    
    @Published var votes = [Vote]()
    @Published var isLoading = false
    
    private let pageLimit = 20
    private let onChainNounsService: OnChainNounsService
    
    init(
      auction: Auction,
      onChainNounsService: OnChainNounsService = AppCore.shared.onChainNounsService
    ) {
      self.auction = auction
      self.onChainNounsService = onChainNounsService
    }
    
    var title: String {
      auction.noun.owner.id
    }
    
    @MainActor
    func fetchActivity() {
      Task {
        do {
          votes += try await onChainNounsService.fetchActivity(for: auction.noun.id, limit: pageLimit, after: votes.count)
          
        } catch { }
      }
    }
  }
}
