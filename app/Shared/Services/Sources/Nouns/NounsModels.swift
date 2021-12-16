//
//  NounsModels.swift
//  
//
//  Created by Ziad Tamim on 15.11.21.
//

import Foundation

/// Pagination.
public struct Page<T> where T: Decodable {
    
    /// Data retrived from the response.
    public let data: T
}

/// The Noun
public struct Noun: Equatable, Decodable, Identifiable {
    
    /// The Noun's ERC721 token id
    public let id: String
    
    ///  The owner of the Noun
    public let owner: Account
    
    /// The seed used to determine the Noun's traits.
    public let seed: Seed
}

/// The seed used to determine the Noun's traits.
public struct Seed: Equatable {
    
    /// The background trait.
    public let background: Int
    
    /// The glasses trait.
    public let glasses: Int
    
    /// The head trait.
    public let head: Int
    
    /// The body trait.
    public let body: Int
    
    /// The accessory trait.
    public let accessory: Int
}

/// The owner of the Noun
public struct Account: Equatable, Decodable {
    
    /// An Account is any address that holds any
    /// amount of Nouns, the id used is the blockchain address.
    public let id: String
}

/// Historical votes for the Noun.
public struct Vote: Equatable, Decodable {
    
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
    public let startTime: String
    
    /// The time that the auction is scheduled to end
    public let endTime: String
    
    /// Whether or not the auction has been settled
    public let settled: Bool
}

/// The auction's Bid
public struct Bid: Equatable, Decodable {
    
    /// Bid transaction hash
    public let id: String
    
    /// Bid amount
    public let amount: String
    
    /// Timestamp of the bid
    public let blockTimestamp: String
    
    /// The account the bid was made by
    public let bidder: Account
}
