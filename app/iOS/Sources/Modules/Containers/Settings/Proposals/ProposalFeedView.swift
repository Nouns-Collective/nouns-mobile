//
//  ProposalFeedView.swift
//  Nouns
//
//  Created by Ziad Tamim on 06.12.21.
//

import SwiftUI
import UIComponents
import Services

/// List all proposals with pagination.
struct ProposalFeedView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.outlineTabViewHeight) private var tabBarHeight
  
  @StateObject var viewModel: ViewModel
  
  @State private var isGovernanceInfoPresented = false
  
  private let localize = R.string.proposal.self
  
  private let gridLayout = [
    GridItem(.flexible(), spacing: 20),
  ]
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VPageGrid(
        viewModel.proposals,
        columns: gridLayout,
        isLoading: viewModel.isLoading,
        loadMoreAction: {
          await viewModel.loadProposals()
        }, placeholder: {
          ProposalPlaceholder(count: 4)
        }, content: {
          ProposalRow(viewModel: .init(proposal: $0))
        }
      )
      .padding(.horizontal, 20)
      .padding(.bottom, tabBarHeight)
      // Extra padding between the bottom of the last noun card and the top of the tab view
      .padding(.bottom, 20)
      .ignoresSafeArea()
      .softNavigationTitle(localize.title(), leftAccessory: {
        SoftButton(
          icon: { Image.back },
          action: { dismiss() })
        
      }, rightAccessory: {
        SoftButton(
          icon: { Image.help },
          action: {
            withAnimation {
              isGovernanceInfoPresented.toggle()
            }
          })
      })
    }
    .background(Gradient.bubbleGum)
    .bottomSheet(isPresented: $isGovernanceInfoPresented) {
      GovernanceInfoCard(isPresented: $isGovernanceInfoPresented)
    }
  }
}
