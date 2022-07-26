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

extension ProposalRow {
  
  class ViewModel: ObservableObject {
    let proposal: Proposal
    
    init(proposal: Proposal) {
      self.proposal = proposal
    }
    
    var identifier: String {
      R.string.proposal.identifier(proposal.id)
    }
    
    var title: String {
      proposal.title ?? R.string.shared.untitled()
    }
    
    var proposalURL: URL? {
      URL(string: "https://nouns.wtf/vote/\(proposal.id)")
    }

    func onPresent() {
      AppCore.shared.analytics.logEvent(withEvent: AnalyticsEvent.Event.viewProposal,
                                        parameters: ["proposal_id": proposal.id])
    }
  }
}
