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

struct ActivityRow: View {
  let viewModel: ViewModel
  
  var body: some View {
    PlainCell {
      VStack(alignment: .leading, spacing: 14) {
        HStack(alignment: .center) {
          VoteChip(vote: viewModel.vote)
          
          Spacer()
          
          Text(viewModel.proposalStatus)
            .foregroundColor(Color.componentNounsBlack)
            .font(Font.custom(.medium, relativeTo: .subheadline))
            .opacity(0.5)
        }
        
        Text(viewModel.proposalTitle)
          .fontWeight(.semibold)
        
      }.padding()
    }
  }
}
