//
//  ProposalVote+Decodable.swift
//  
//
//  Created by Mohammed Ibrahim on 2022-01-19.
//

import Foundation

extension ProposalVote: Decodable {
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: AnyCodingKey.self)
    id = try container.decode(String.self, forKey: AnyCodingKey("id"))
    support = try container.decode(Bool.self, forKey: AnyCodingKey("support"))
    
    let votesAsString = try container.decode(String.self, forKey: AnyCodingKey("votes"))
    votes = Int(votesAsString) ?? 0
  }
}
