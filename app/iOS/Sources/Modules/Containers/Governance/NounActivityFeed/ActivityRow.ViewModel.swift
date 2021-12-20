//
//  ActivityRow.ViewModel.swift
//  Nouns
//
//  Created by Ziad Tamim on 17.12.21.
//

import Foundation
import Services

extension ActivityRow {
  
  final class ViewModel: ObservableObject {
    let vote: Vote
    
    init(vote: Vote) {
      self.vote = vote
    }
    
    var proposalTitle: String {
      guard let title = vote.proposal.title else {
        return R.string.activity.proposalUntitled()
      }
      
      return title
    }
    
    var proposalStatus: String {
      R.string.activity.proposalStatus(
        vote.proposal.id,
        vote.proposal.status.rawValue.capitalized)
    }
  }
}
