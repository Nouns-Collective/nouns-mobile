//
//  ExploreExperience.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import SwiftUI
import UIComponents
import Services

/// Housing view for exploring on chain nouns, including
/// the current on-goign auction and previously auctioned nouns
struct ExploreExperience: View {
  @StateObject var viewModel = ViewModel()
  
  @Environment(\.outlineTabViewHeight) private var tabBarHeight

  var body: some View {
    NavigationView {
      ScrollView(.vertical, showsIndicators: false) {
        VStack(spacing: 20) {
          if let auction = viewModel.liveAuction {
            LiveAuctionCard(viewModel: .init(auction: auction))
          } else {
            LiveAuctionCardPlaceholder()
          }
          
          SettledAuctionFeed()
        }
        .padding(.bottom, tabBarHeight)
        .padding(.bottom, 20) // Extra padding between the bottom of the last noun card and the top of the tab view
        .padding(.horizontal, 20)
        .softNavigationTitle(R.string.explore.title())
      }
      // Disable scrolling when data is initially loading.
      .disabled(viewModel.isLoading)
      .background(Gradient.lemonDrop)
      .ignoresSafeArea(edges: .top)
      .task {
        await viewModel.listenLiveAuctionChanges()
      }
    }
  }
}
