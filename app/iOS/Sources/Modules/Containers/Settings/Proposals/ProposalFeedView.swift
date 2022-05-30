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
  @Environment(\.outlineTabBarVisibility) var outlineTabBarVisibility
  
  @StateObject var viewModel: ViewModel
  
  @State private var isGovernanceInfoPresented = false
  
  private let localize = R.string.proposal.self
  
  private let gridLayout = [
    GridItem(.flexible(), spacing: 10),
  ]
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VPageGrid(
        viewModel.proposals,
        columns: gridLayout,
        spacing: 10,
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
      .padding(.top, 50)
    }
    .background(Gradient.lemonDrop)
    .overlay(.componentUnripeLemon, edge: .top)
    .ignoresSafeArea(edges: .top)
    .bottomSheet(isPresented: $isGovernanceInfoPresented) {
      GovernanceInfoCard(
        isPresented: $isGovernanceInfoPresented,
        nounId: nil,
        owner: nil,
        page: nil
      )
    }
    .onAppear {
      viewModel.onAppear()
      outlineTabBarVisibility.hide()
    }
  }
}
