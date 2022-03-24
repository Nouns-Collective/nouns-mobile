//
//  Proposal+Decodable.swift
//  
//
//  Created by Ziad Tamim on 18.12.21.
//

import Foundation

extension Proposal: Decodable {
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: AnyCodingKey.self)
    id = try container.decode(String.self, forKey: AnyCodingKey("id"))
    status = try container.decode(ProposalStatus.self, forKey: AnyCodingKey("status"))
    description = try container.decode(String.self, forKey: AnyCodingKey("description"))
    title = MarkdownParser(content: description).title
    votes = try container.decode([ProposalVote].self, forKey: AnyCodingKey("votes"))
    
    let quorumVotesAsString = try container.decode(String.self, forKey: AnyCodingKey("quorumVotes"))
    quorumVotes = Int(quorumVotesAsString) ?? 0
    
    if let executionETAAsString = try container.decodeIfPresent(String.self, forKey: AnyCodingKey("executionETA")) {
      executionETA = try TimeIntervalDecoder.timeInterval(executionETAAsString, decoder)
    } else {
      executionETA = nil
    }
    
    if let createdTimestampAsString = try container.decodeIfPresent(String.self, forKey: AnyCodingKey("createdTimestamp")) {
      createdTimestamp = try TimeIntervalDecoder.timeInterval(createdTimestampAsString, decoder)
    } else {
      createdTimestamp = nil
    }
  }
}
