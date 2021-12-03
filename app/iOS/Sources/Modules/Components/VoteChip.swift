//
//  VoteChip.swift
//  Nouns
//
//  Created by Ziad Tamim on 03.12.21.
//

import SwiftUI
import UIComponents
import Services

/// Displays different Vote states using the ``ChipLabel`` component.
struct VoteChip: View {
  let vote: Vote
  
  var body: some View {
    switch vote.supportDetailed {
    case .abstain:
      return ChipLabel(R.string.activity.absent(), state: .neutral)
      
    case .for:
      return ChipLabel(R.string.activity.for(), state: .positive)
      
    case .against:
      return ChipLabel(R.string.activity.against(), state: .negative)
    }
  }
}
