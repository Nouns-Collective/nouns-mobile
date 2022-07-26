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
