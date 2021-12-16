//
//  SettledAuctionFeed.swift
//  Nouns
//
//  Created by Ziad Tamim on 01.12.21.
//

import SwiftUI
import Services
import UIComponents

extension SettledAuctionFeed {
  
  @MainActor
  class ViewModel: ObservableObject {
    @Published var auctions = [Auction]()
    @Published var isFetching = false
    
    private let pageLimit = 20
    private var cloudNounsService: CloudNounsService
    
    init(cloudNounsService: CloudNounsService = AppCore.shared.cloudNounsService) {
      self.cloudNounsService = cloudNounsService
    }
    
    func loadData() {
      Task {
        do {
          isFetching = true
          
          // load next batch of the settled auctions from the network.
          auctions = try await cloudNounsService.fetchAuctions(
            settled: true,
            limit: pageLimit,
            cursor: auctions.count
          )
        } catch  { }
        
        isFetching = false
      }
    }
  }
}

/// Displays Settled Auction Feed.
struct SettledAuctionFeed: View {
  @StateObject var viewModel = SettledAuctionFeed.ViewModel()
  
  @State private var selection: Auction?
  
  private let gridLayout = [
    GridItem(.flexible(), spacing: 20),
    GridItem(.flexible(), spacing: 20),
  ]
  
  var body: some View {
    VPageGrid(viewModel.auctions, columns: gridLayout, loadMoreAction: {
      // load next settled auctions batch.
      viewModel.loadData()
      
    }, placeholder: {
      // An activity indicator while loading auctions from the network.
      CardPlaceholder(count: 2)
      
    }, content: { auction in
      SettledAuctionCard(viewModel: .init(auction: auction))
        .onTapGesture {
          withAnimation(.spring()) {
            selection = auction
          }
        }
    })
    // Presents more details about the settled auction.
      .fullScreenCover(item: $selection, onDismiss: {
        selection = nil
        
      }, content: { auction in
        NounProfileInfoCard(auction: auction)
      })
  }
}

/// Displays a settled auction along with the date it was created, the owner, and a status label.
struct SettledAuctionCard: View {
  @StateObject var viewModel: ViewModel
  
  @Environment(\.nounComposer) private var nounComposer: NounComposer
  
  var body: some View {
    StandardCard(media: {
      NounPuzzle(seed: viewModel.auction.noun.seed)
        .background(Color(hex: nounComposer.backgroundColors[viewModel.auction.noun.seed.background]))
      
    }, smallHeader: R.string.explore.noun(viewModel.auction.noun.id), accessoryImage: Image.mdArrowCorner, detail: {
      SafeLabel(viewModel.winnerBid, icon: Image.eth)
    })
  }
}

extension SettledAuctionCard {
  
  class ViewModel: ObservableObject {
    let auction: Auction
    
    init(auction: Auction) {
      self.auction = auction
    }
    
    var winnerBid: String {
      guard let bid = EtherFormatter.eth(
        from: auction.amount
      ) else {
        return R.string.shared.notApplicable()
      }
      
      return bid
    }
  }
}
