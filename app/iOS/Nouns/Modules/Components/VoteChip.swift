//
//  VoteChip.swift
//  Nouns
//
//  Created by Ziad Tamim on 03.12.21.
//

import SwiftUI
import NounsUI
import Services

/// Displays different Vote states using the `ChipLabel` component.
struct VoteChip: View {
  let vote: Vote
  
  var body: some View {
    switch vote.supportDetailed {
    case .abstain:
      return ChipLabel(R.string.activity.absent(), state: .cancelled)
      
    case .for:
      return ChipLabel(R.string.activity.for(), state: .executed)
      
    case .against:
      return ChipLabel(R.string.activity.against(), state: .vetoed)
    }
  }
}
