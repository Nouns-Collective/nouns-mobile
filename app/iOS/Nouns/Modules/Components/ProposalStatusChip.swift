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
