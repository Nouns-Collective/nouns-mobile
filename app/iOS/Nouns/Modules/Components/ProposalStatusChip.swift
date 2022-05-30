//
//  ProposalStatusChip.swift
//  Nouns
//
//  Created by Ziad Tamim on 06.12.21.
//

import SwiftUI
import NounsUI
import Services

struct ProposalStatusChip: View {
  let proposal: Proposal
  
  private var title: String {
    state.rawValue.capitalized
  }
  
  private var state: ChipLabel.State {
    switch proposal.detailedStatus {
    case .pending:
      return .pending
    case .defeated:
      return .defeated
    case .succeeded:
      return .succeeded
    case .cancelled:
      return .cancelled
    case .vetoed:
      return .vetoed
    case .queued:
      return .queued
    case .executed:
      return .executed
    case .expired:
      return .expired
    case .active:
      return .active
    }
  }
  
  var body: some View {
    ChipLabel(title, state: state)
  }
}
