// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Ziad Tamim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
    func loadProposals(reload: Bool = false) {
      Task {
        do {
          isLoading = true
          let proposals = try await onChainNounsService.fetchProposals(
            limit: pageLimit,
            after: reload ? 0 : proposals.count
          )

          if reload {
            self.proposals = []
          }
          
          self.proposals += proposals.data
          self.shouldLoadMore = proposals.hasNext
        } catch { }
        
        isLoading = false
      }
    }

    func onAppear() {
      AppCore.shared.analytics.logScreenView(withScreen: AnalyticsEvent.Screen.proposals)
    }
  }
}
