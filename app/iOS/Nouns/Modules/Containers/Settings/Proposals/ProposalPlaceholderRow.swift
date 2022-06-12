// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Mohammed Ibrahim
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

/// A row cell to show as a placeholder for when proposals are loading
struct ProposalPlaceholderRow: View {
  
  var body: some View {
    
    PlainCell {
      VStack(alignment: .leading, spacing: 20) {
        HStack {
          Text("Proposal 00")
            .font(.custom(.regular, relativeTo: .caption))
            .redactable(style: .skeleton)
          
          Spacer()
          
          ChipLabel("Loading", state: .pending)
            .redactable(style: .gray)
            .clipShape(Capsule())
        }
        
        Text("Proposal Placeholder Title")
          .font(.custom(.medium, relativeTo: .subheadline))
          .redactable(style: .skeleton)
        
      }.padding()
    }
  }
}
