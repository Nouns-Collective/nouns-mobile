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

/// Provides Proposal info.
struct ProposalRow: View {
  @StateObject var viewModel: ViewModel
  
  @State private var isDescriptionPresented = false
  
  var body: some View {
    PlainCell {
      VStack(alignment: .leading, spacing: 20) {
        HStack {
          Text(viewModel.identifier)
            .font(.custom(.regular, relativeTo: .caption))
          
          Spacer()
          
          ProposalStatusChip(proposal: viewModel.proposal)
        }
        
        Text(viewModel.title)
          .font(.custom(.medium, relativeTo: .subheadline))
        
      }.padding()
    }
    .onTapGesture {
      viewModel.onPresent()
      isDescriptionPresented.toggle()
    }
    .fullScreenCover(isPresented: $isDescriptionPresented) {
      if let url = viewModel.proposalURL {
        Safari(url: url)
      }
    }
  }
}