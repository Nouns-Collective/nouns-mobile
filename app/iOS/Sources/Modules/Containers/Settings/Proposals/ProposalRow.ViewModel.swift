//
//  ProposalRow.ViewModel.swift
//  Nouns
//
//  Created by Ziad Tamim on 17.12.21.
//

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
  }
}
