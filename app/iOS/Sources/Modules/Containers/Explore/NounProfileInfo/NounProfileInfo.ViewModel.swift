//
//  NounProfileView.ViewModel.swift
//  Nouns
//
//  Created by Ziad Tamim on 16.12.21.
//

import Foundation
import Services
import UIKit

extension NounProfileInfo {
  
  class ViewModel: ObservableObject {
    @Published private(set) var title: String
    @Published private(set) var nounTraits: Seed
    @Published private(set) var isAuctionSettled: Bool
    @Published private(set) var nounProfileURL: URL?
    
    /// Indicate whether the auction time is over.
    @Published private(set) var isWinnerAnounced = false
    
    /// A boolean to indicate whether the notification permission
    /// dialog is presented only on `notDetermined` state.
    @Published private(set) var isNotificationPermissionDialogPresented = false
    
    /// A boolean to indicate whether the user chose the option to enable the notification or dismiss it.
    @Published var isNotificationPermissionEnabled = false {
      didSet {
        if isNotificationPermissionEnabled {
          setUpMessaging()
        }
        // Dismisses the dialog currently presented.
        isNotificationPermissionDialogPresented = false
      }
    }
    
    let auction: Auction
    
    init(
      auction: Auction,
      messaging: Messaging = AppCore.shared.messaging
    ) {
      self.auction = auction
      
      title = R.string.explore.noun(auction.noun.id)
      isAuctionSettled = auction.settled
      isWinnerAnounced = auction.hasEnded
      nounTraits = auction.noun.seed
      nounProfileURL = URL(string: "https://nouns.wtf/noun/\(auction.noun.id)")
      
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
    
    func setUpMessaging() {
      let messaging = AppCore.shared.messaging
      let settingsStore = AppCore.shared.settingsStore
      // Subscribe to topics on APNs registration.
      messaging.onRegistrationCompletion = {
        settingsStore.syncMessagingTopicsSubscription()
      }
      
      Task {
        // Requests APNs authorization.
        _ = try await messaging.requestAuthorization(
          UIApplication.shared,
          authorizationOptions: [.alert, .badge, .sound]
        )
      }
    }
  }
}
