//
//  ProposalFeedView.ViewModel.swift
//  Nouns
//
//  Created by Ziad Tamim on 17.12.21.
//

import Foundation
import Services

extension ProposalFeedView {
  
  class ViewModel: ObservableObject {
    @Published var proposals = [Proposal]()
    @Published var isLoading = false
    @Published var shouldLoadMore: Bool = true
    
    public var isInitiallyLoading: Bool {
      isLoading && proposals.isEmpty
    }
    
    private let pageLimit = 20
    private let onChainNounsService: OnChainNounsService
    
    init(onChainNounsService: OnChainNounsService = AppCore.shared.onChainNounsService) {
      self.onChainNounsService = onChainNounsService
    }
    
    @MainActor
    func loadProposals() {
      Task {
        do {
          isLoading = true
          let proposals = try await onChainNounsService.fetchProposals(
            limit: pageLimit,
            after: proposals.count
          )
          
          self.proposals += proposals.data
          self.shouldLoadMore = proposals.hasNext
        } catch { }
        
        isLoading = false
      }
    }
  }
}
