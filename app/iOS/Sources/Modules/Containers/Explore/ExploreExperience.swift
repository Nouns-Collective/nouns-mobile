//
//  ExploreExperience.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import SwiftUI
import UIComponents
import Services

/// Housing view for exploring on chain nouns, including the current on-goign auction and previously auctioned nouns
struct ExploreExperience: View {
  @StateObject var viewModel = ViewModel()
  
  var body: some View {
    NavigationView {
      ScrollView(.vertical, showsIndicators: false) {
        VStack(spacing: 20) {
          if let auction = viewModel.liveAuction {
            LiveAuctionCard(viewModel: .init(auction: auction))
          }
          
          SettledAuctionFeed()
        }
        .padding(.horizontal, 20)
        .softNavigationTitle(R.string.explore.title())
      }
      // Disable scrolling when data is initially loading.
      .disabled(viewModel.isFetching)
      .background(Gradient.lemonDrop)
      .ignoresSafeArea()
    }
  }
}

extension ExploreExperience {
  
  @MainActor
  class ViewModel: ObservableObject {
    @Published var liveAuction: Auction?
    @Published var isFetching = false
    
    private let cloudNounsService: CloudNounsService
    
    init(cloudNounsService: CloudNounsService = AppCore.shared.cloudNounsService) {
      self.cloudNounsService = cloudNounsService
    }
    
    private func listenLiveAuctionChanges() {
      Task {
        do {
          isFetching = true
          liveAuction = try await cloudNounsService.liveAuctionStateDidChange()
          
        } catch { }
        
        isFetching = false
      }
    }
  }
}
