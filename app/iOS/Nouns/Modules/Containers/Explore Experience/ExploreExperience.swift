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
