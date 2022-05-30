//
//  ExploreExperience.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import SwiftUI
import NounsUI
import Services

/// Housing view for exploring on chain nouns, including
/// the current on-goign auction and previously auctioned nouns
struct ExploreExperience: View {
  @StateObject var viewModel = ViewModel()
  
  @Environment(\.outlineTabViewHeight) private var tabBarHeight

  var body: some View {
    NavigationView {
      ScrollView(.vertical, showsIndicators: false) {
        VStack(spacing: 16) {
          if let auction = viewModel.liveAuction {
            LiveAuctionCard(viewModel: .init(auction: auction))
          } else if viewModel.failedToLoadLiveAuction {
            LiveAuctionCardErrorPlaceholder(viewModel: viewModel)
          } else {
            LiveAuctionCardPlaceholder()
          }
          
          SettledAuctionFeed(viewModel: viewModel)
        }
        .padding(.bottom, tabBarHeight)
        .padding(.bottom, 20) // Extra padding between the bottom of the last noun card and the top of the tab view
        .padding(.horizontal, 20)
        .emptyPlaceholder(when: viewModel.failedToLoadExplore) {
          EmptyErrorView(viewModel: viewModel)
            .padding()
        }
        .softNavigationTitle(R.string.explore.title())
        .id(AppPage.explore.scrollToTopId)
      }
      .disabled(viewModel.isLoadingSettledAuctions)
      .background(Gradient.cherrySunset)
      .overlay(.componentPeachy, edge: .top)
      .ignoresSafeArea(edges: .top)
    }
    .onAppear {
      viewModel.onAppear()
      Task {
        await viewModel.listenLiveAuctionChanges()
      }
    }
  }
}
