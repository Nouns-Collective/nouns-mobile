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
    private let service: OnChainNounsService
    
    init(
      auction: Auction,
      service: OnChainNounsService = AppCore.shared.onChainNounsService
    ) {
      self.auction = auction
      self.service = service
    }
    
    var title: String {
      auction.noun.owner.id
    }
    
    @MainActor
    func fetchActivity() async {
      do {
        votes += try await service.fetchActivity(
          for: auction.noun.id,
             limit: pageLimit,
             after: votes.count
        )
        
      } catch { }
    }
  }
}
