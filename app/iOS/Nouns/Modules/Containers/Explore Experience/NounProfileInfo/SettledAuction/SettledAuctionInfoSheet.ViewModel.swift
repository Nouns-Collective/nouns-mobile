//
//  SettledAuctionInfoCard.ViewModel.swift
//  Nouns
//
//  Created by Ziad Tamim on 16.12.21.
//

import Foundation
import Services

extension SettledAuctionInfoSheet {
  
  class ViewModel: ObservableObject {
    @Published private(set) var winner: String
    @Published private(set) var birthdate: String
    @Published private(set) var winningBid: String
    @Published private(set) var nounProfileURL: URL?
    @Published private(set) var showWinningBid: Bool
    @Published private(set) var showBirthdate: Bool
    @Published private(set) var governanceTitle: String
    @Published private(set) var domain: String?
    
    private let auction: Auction
    
    /// Holds a reference to the localized text.
    private let localize = R.string.nounProfile.self
    
    public var isNounderOwned: Bool {
      auction.noun.isNounderOwned
    }
    
    init(
      auction: Auction
    ) {
      self.auction = auction
      
      winner = auction.noun.owner.id
      let amount = EtherFormatter.eth(from: auction.amount)
      winningBid = amount ?? R.string.shared.notApplicable()
      nounProfileURL = URL(string: "https://nouns.wtf/noun/\(auction.noun.id)")
      
      let startDate = Date(timeIntervalSince1970: auction.startTime)
      birthdate = localize.birthday(startDate.formatted(dateStyle: .long))
      
      // Hide the winning bid on the nounders noun.
      showWinningBid = !auction.noun.isNounderOwned
      
      // TODO: Modify the nounders nouns retrieval logic to infer
      // the birthday from the previously auctioned noun.
      // Hide the birthday on the nounders noun as it isn't provided.
      showBirthdate = !auction.noun.isNounderOwned
      
      // On nounder noun, display activity as the only option.
      if auction.noun.isNounderOwned {
        governanceTitle = localize.auctionSettledGovernanceNounder()
      } else {
        governanceTitle = localize.auctionSettledGovernance()
      }
    }
  }
}
