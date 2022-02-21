//
//  ProposalsInfoSection.swift
//  Nouns
//
//  Created by Ziad Tamim on 05.12.21.
//

import SwiftUI
import UIComponents
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
        .emptyPlaceholder(when: viewModel.isLoading) {
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
      viewModel.loadProposals()
    }
  }
}
