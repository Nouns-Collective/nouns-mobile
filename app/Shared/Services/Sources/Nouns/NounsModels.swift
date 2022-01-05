//
//  NounsModels.swift
//  
//
//  Created by Ziad Tamim on 15.11.21.
//

import Foundation
import SwiftUI

/// Pagination.
public struct Page<T> where T: Decodable {
  
  /// Data retrived from the response.
  public let data: T
}

/// The Noun
public struct Noun: Equatable, Identifiable, Hashable {
  
  /// The Noun's ERC721 token id
  public let id: String
  
  /// The given Noun's name.
  public var name: String
  
  ///  The owner of the Noun.
  public let owner: Account
  
  /// The seed used to determine the Noun's traits.
  public var seed: Seed
  
  /// The date when the noun was created.
  public let createdAt: Date
  
  /// The date when the noun was updated.
  public var updatedAt: Date
  
  public init(
    id: String = UUID().uuidString,
    name: String,
    owner: Account,
    seed: Seed,
    createdAt: Date = .now,
    updatedAt: Date = .now
  ) {
    self.id = id
    self.name = name
    self.owner = owner
    self.seed = seed
    self.createdAt = createdAt
    self.updatedAt = updatedAt
  }
}

/// The seed used to determine the Noun's traits.
public struct Seed: Equatable, Hashable {
  
  /// The background trait.
  public var background: Int
  
  /// The glasses trait.
  public var glasses: Int
  
  /// The head trait.
  public var head: Int
  
  /// The body trait.
  public var body: Int
  
  /// The accessory trait.
  public var accessory: Int
  
  public init(background: Int, glasses: Int, head: Int, body: Int, accessory: Int) {
    self.background = background
    self.glasses = glasses
    self.head = head
    self.body = body
    self.accessory = accessory
  }
}

/// The owner of the Noun
public struct Account: Equatable, Decodable, Hashable {
  
  /// An Account is any address that holds any
  /// amount of Nouns, the id used is the blockchain address.
  public let id: String
  
  public init(id: String = UUID().uuidString) {
    self.id = id
  }
}

/// Historical votes for the Noun.
public struct Vote: Equatable, Decodable, Identifiable {
  
  /// Delegate ID + Proposal ID
  public let id: String
  
  /// The support value: against, for, or abstain.
  public let supportDetailed: VoteSupportDetailed
  
  /// Proposal that is being voted on.
  public let proposal: Proposal
}

/// Vote support value.
public enum VoteSupportDetailed: Int, Decodable {
  case against
  case `for`
  case abstain
}

/// Status of the proposal
public enum ProposalStatus: String, Decodable {
  case pending = "PENDING"
  case active = "ACTIVE"
  case cancelled = "CANCELLED"
  case vetoed = "VETOED"
  case queued = "QUEUED"
  case executed = "EXECUTED"
}

/// The Proposal.
public struct Proposal: Equatable {
  
  /// Internal proposal ID
  public let id: String
  
  /// Title of the change
  public let title: String?
  
  /// Description of the change.
  public let description: String
  
  /// Status of the proposal.
  public let status: ProposalStatus
}

/// The Auction
public struct Auction: Equatable, Decodable, Identifiable {
  /// The Noun's ERC721 token id
  public let id: String
  
  /// The Noun
  public let noun: Noun
  
  /// The current highest bid amount
  public let amount: String
  
  /// The time that the auction started
  public let startTime: TimeInterval
  
  /// The time that the auction is scheduled to end
  public let endTime: TimeInterval
  
  /// Whether or not the auction has been settled
  public let settled: Bool
  
  /// The auction bids.
  public let bidder: Account
  
  /// Whether the auction is over and bidding is stopped.
  public var hasEnded: Bool {
    Date().timeIntervalSince1970 > endTime
  }
  
  /// Calculate the time left for the auction to end.
  public var timeLeft: DateComponents {
    Calendar.current.dateComponents(
      [.hour, .minute, .second],
      from: .now,
      to: Date(timeIntervalSince1970: endTime)
    )
  }
}

/// The auction's Bid
public struct Bid: Equatable, Decodable, Identifiable {
  
  /// Bid transaction hash
  public let id: String
  
  /// Bid amount
  public let amount: String
  
  /// Timestamp of the bid
  public let blockTimestamp: String
  
  /// The account the bid was made by
  public let bidder: Account
}
