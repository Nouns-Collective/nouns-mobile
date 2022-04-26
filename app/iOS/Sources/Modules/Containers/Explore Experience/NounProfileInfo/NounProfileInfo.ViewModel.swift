//
//  NounProfileView.ViewModel.swift
//  Nouns
//
//  Created by Ziad Tamim on 16.12.21.
//

import Foundation
import Services

extension NounProfileInfo {
  
  final class ViewModel: ObservableObject {
    @Published private(set) var title: String
    @Published private(set) var nounTraits: Seed
    @Published private(set) var isAuctionSettled: Bool
    @Published private(set) var nounProfileURL: URL?
    @Published var shouldShowNounCreator: Bool = false
    
    /// Indicate whether the auction time is over.
    @Published private(set) var isWinnerAnnounced = false
    
    /// A boolean to indicate whether the notification permission
    /// dialog is presented only on `notDetermined` state.
    @Published var isNotificationPermissionDialogPresented = false
    
    let auction: Auction
    
    init(
      auction: Auction,
      messaging: Messaging = AppCore.shared.messaging
    ) {
      self.auction = auction
      
      title = R.string.explore.noun(auction.noun.id)
      isAuctionSettled = auction.settled
      isWinnerAnnounced = auction.hasEnded
      nounTraits = auction.noun.seed
      nounProfileURL = URL(string: R.string.shared.nounsProfileWebsite(auction.noun.id))
      
      Task {
        guard await messaging.authorizationStatus == .notDetermined else {
          return
        }
        
        // Gives a buffer of 0.5 seconds before presenting
        // the notification permission dialog.
        try await Task.sleep(nanoseconds: 500_000_000)
        
        await MainActor.run {
          isNotificationPermissionDialogPresented = true
        }
      }
    }

    func onAppear() {
      let screen = isAuctionSettled ? AnalyticsEvent.Screen.settledNounProfile
                                    : AnalyticsEvent.Screen.auctionNounProfile
      AppCore.shared.analytics.logScreenView(withScreen: screen)

      let parameters: [String: Any] = ["noun_id": auction.noun.id, "is_auction_noun": !isAuctionSettled]
      AppCore.shared.analytics.logEvent(withEvent: AnalyticsEvent.Event.viewNounProfile,
                                        parameters: parameters)
    }
  }
}
