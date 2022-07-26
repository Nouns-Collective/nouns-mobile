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

/// List a few proposals while giving the option to see all.
struct ProposalsInfoSection: View {
  @StateObject var viewModel = ProposalFeedView.ViewModel()
  
  @State private var isProposalFeedPresented = false
  private let numberOfVisibleProposals = 4
  private let localize = R.string.proposal.self
  
  var body: some View {
    VStack(alignment: .leading, spacing: 5) {
      AboutView.SectionTitle(
        title: localize.title(),
        subtitle: localize.message())
      
      LazyVStack {
        ForEach(
          viewModel.proposals.prefix(numberOfVisibleProposals),
          id: \.id
        ) {
          ProposalRow(viewModel: .init(proposal: $0))
        }
        .emptyPlaceholder(when: viewModel.isInitiallyLoading) {
          ProposalPlaceholder(count: 4)
            .loading()
        }
      }
      
      SoftNavigationLink(
        isActive: $isProposalFeedPresented,
        title: localize.seeAll(),
        trailing: { Image.mdArrowRight },
        destination: { ProposalFeedView(viewModel: viewModel) })
    }
    .onAppear {
      viewModel.loadProposals(reload: true)
    }
  }
}
