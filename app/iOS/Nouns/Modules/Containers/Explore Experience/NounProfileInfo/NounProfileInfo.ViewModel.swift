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
