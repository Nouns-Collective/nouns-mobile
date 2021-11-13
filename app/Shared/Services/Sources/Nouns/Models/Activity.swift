//
//  File.swift
//  
//
//  Created by Ziad Tamim on 13.11.21.
//

import Foundation

/// Historical votes for the Noun.
public struct Vote: Decodable {
    
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
public struct Proposal {
    
    /// Internal proposal ID
    public let id: String
    
    /// Title of the change
    public let title: String?
    
    /// Description of the change.
    public let description: String
    
    /// Status of the proposal.
    public let status: ProposalStatus
}

extension Proposal: Decodable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnyCodingKey.self)
        id = try container.decode(String.self, forKey: AnyCodingKey("id"))
        status = try container.decode(ProposalStatus.self, forKey: AnyCodingKey("status"))
        description = try container.decode(String.self, forKey: AnyCodingKey("description"))
        title = MarkdownParser(content: description).title
    }
    
}
