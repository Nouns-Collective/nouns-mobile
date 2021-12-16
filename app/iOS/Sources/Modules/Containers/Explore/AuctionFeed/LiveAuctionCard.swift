//
//  LiveAuctionCard.swift
//  Nouns
//
//  Created by Ziad Tamim on 01.12.21.
//

import SwiftUI
import Services
import Combine
import UIComponents

extension LiveAuctionCard {
  
  @MainActor
  class ViewModel: ObservableObject {
    @Published var auction: Auction
    @Published var isFetching = false
    @Published var remainingTime =  R.string.shared.notApplicable()
    
    private let cloudNounsService: CloudNounsService
    
    init(
      auction: Auction,
      cloudNounsService: CloudNounsService = AppCore.shared.cloudNounsService
    ) {
      self.auction = auction
      self.cloudNounsService = cloudNounsService
      
      setUpAuctionTimer()
    }
    
    var title: String {
      R.string.explore.noun(auction.noun.id)
    }
    
    var currentBid: String {
      guard let amount = EtherFormatter.eth(
        from: auction.amount
      ) else {
        return R.string.shared.notApplicable()
      }
      
      return amount
    }
    
    private func setUpAuctionTimer() {
      // Timer sequence to emit every 1 second.
      let componentsSequence = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()
        .compactMap { _ -> DateComponents? in
          guard let endDateTimeInterval = Double(self.auction.endTime) else {
            return nil
          }

          let now = Date()
          let end = Date(timeIntervalSince1970: endDateTimeInterval)
          return Calendar.current.dateComponents(
            [.hour, .minute, .second],
            from: now,
            to: end
          )
        }
        .values
      
      // Update the remaining time.
      Task {
        for await components in componentsSequence {
          guard let hour = components.hour,
                let minute = components.minute,
                let second = components.second
          else {
            continue
          }

          remainingTime = R.string.liveAuction.timeLeft(hour, minute, second)
        }
      }
    }
  }
}


/// Diplay the auction of the day in real time.
struct LiveAuctionCard: View {
  @StateObject var viewModel: ViewModel
  
  @Environment(\.nounComposer) private var nounComposer: NounComposer
  
  var body: some View {
    StandardCard(
      media: {
        NounPuzzle(seed: viewModel.auction.noun.seed)
          .background(Color(hex: nounComposer.backgroundColors[viewModel.auction.noun.seed.background]))
      },
      header: viewModel.title,
      accessoryImage: Image.mdArrowCorner,
      leftDetail: {
        // Displays Remaining Time.
        CompoundLabel(
          Text(viewModel.remainingTime),
          icon: Image.timeleft,
          caption: R.string.liveAuction.timeLeftLabel())
      },
      rightDetail: {
        // Displays Current Bid.
        CompoundLabel(
          SafeLabel(viewModel.currentBid, icon: Image.eth),
          icon: Image.currentBid,
          caption: R.string.liveAuction.currentBid())
      })
  }
}
