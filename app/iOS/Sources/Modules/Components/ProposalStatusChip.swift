//
//  ProposalStatusChip.swift
//  Nouns
//
//  Created by Ziad Tamim on 06.12.21.
//

import SwiftUI
import UIComponents
import Services

struct ProposalStatusChip: View {
  let proposal: Proposal
  
  private var title: String {
    state.rawValue.capitalized
  }
  
  private var state: ChipLabel.State {
    switch proposal.status {
    case .pending:
      return .pending
    case .active:
      return proposal.isDefeated ? .defeated : .succeeded
    case .cancelled:
      return .cancelled
    case .vetoed:
      return .vetoed
    case .queued:
      return .queued
    case .executed:
      return .executed
    }
  }
  
  var body: some View {
    ChipLabel(title, state: state)
  }
}
