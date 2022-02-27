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
  public var data: T
  
  /// The cursor of the current page
  public var cursor: Int = 0
  
  /// Whether there is more data to fetch
  public var hasNext: Bool = true
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
  
  public var isNounderOwned: Bool
  
  public init(
    id: String = UUID().uuidString,
    name: String,
    owner: Account,
    seed: Seed,
    createdAt: Date = .now,
    updatedAt: Date = .now,
    nounderOwned: Bool = false
  ) {
    self.id = id
    self.name = name
    self.owner = owner
    self.seed = seed
    self.createdAt = createdAt
    self.updatedAt = updatedAt
    self.isNounderOwned = nounderOwned
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
  
  public init?(background: String, glasses: String, head: String, body: String, accessory: String) {
    guard let backgroundInt = Int(background),
          let glassesInt = Int(glasses),
          let headInt = Int(head),
          let bodyInt = Int(body),
          let accessoryInt = Int(accessory) else {
            return nil
          }
    
    self.background = backgroundInt
    self.glasses = glassesInt
    self.head = headInt
    self.body = bodyInt
    self.accessory = accessoryInt
  }
}

public extension Seed {
  static let `default` = Seed(background: 0, glasses: 0, head: 0, body: 0, accessory: 0)
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

/// A proposal status that provides more details and logic to match the website's display status
public enum ProposalDetailedStatus: String {
  case pending
  case cancelled
  case vetoed
  case queued
  case executed
  
  case expired
  
  case defeated
  case succeeded
  
  static func status(from proposal: Proposal) -> ProposalDetailedStatus {
    switch proposal.status {
    case .pending:
      return .pending
    case .active:
      // Active proposals are displayed as either succeeded or defeated
      return proposal.isDefeated ? .defeated : .succeeded
    case .cancelled:
      return .cancelled
    case .vetoed:
      return .vetoed
    case .queued:
      // Proposals that are queued are considered expired if two weeks after the executionETA has passed
      if let executionETA = proposal.executionETA {
        var dateComponents = DateComponents()
        dateComponents.weekOfYear = 2 // For removing one day (yesterday): -1
        if let expiryDate = Calendar.current.date(byAdding: dateComponents, to: Date(timeIntervalSince1970: executionETA)) {
          let currentDate = Date()
          
          if currentDate > expiryDate {
            return .expired
          }
        }
      }
      return .queued
    case .executed:
      return .executed
    }
  }
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
  
  /// Votes associated with this proposal
  public let votes: [ProposalVote]
  
  /// The required number of votes for quorum at the time of proposal creation
  public let quorumVotes: Int
  
  /// Once the proposal is queued for execution it will have an ETA of the execution
  public let executionETA: TimeInterval?

  /// The amount of votes in favour of this proposal
  public var forVotes: Int {
    votes.filter { $0.support == true }.map { $0.votes }.reduce(0, +)
  }

  /// The amount of votes against this proposal
  public var againstVotes: Int {
    votes.filter { $0.support == false }.map { $0.votes }.reduce(0, +)
  }
  
  /// A boolean value to determine if this proposal is defeated
  public var isDefeated: Bool {
    quorumVotes > forVotes || againstVotes >= forVotes
  }
  
  /// A more accurate user-facing proposal status, in line with how the Nouns website displays proposal status
  /// The `active` status is replaced in favour of a specific succeeded or defeated status
  public var detailedStatus: ProposalDetailedStatus {
    ProposalDetailedStatus.status(from: self)
  }
}

public struct ProposalVote: Equatable, Identifiable {
  
  /// Delegate ID + Proposal ID
  public let id: String
  
  /// Whether the vote is in favour of the proposal
  public let support: Bool
  
  /// Amount of votes in favour or against expressed as a BigInt normalized value for the Nouns ERC721 Token
  public let votes: Int
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
  
  /// The auctions current highest bid
  public let bidder: Account?
  
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
